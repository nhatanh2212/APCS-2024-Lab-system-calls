
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c8010113          	add	sp,sp,-896 # 80019c80 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	179050ef          	jal	8000598e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	add	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	sll	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d5078793          	add	a5,a5,-688 # 80021d80 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	sll	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8c090913          	add	s2,s2,-1856 # 80008910 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	382080e7          	jalr	898(ra) # 800063dc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	422080e7          	jalr	1058(ra) # 80006490 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	add	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	add	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	dd8080e7          	jalr	-552(ra) # 80005e62 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	add	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	add	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	add	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	add	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	82250513          	add	a0,a0,-2014 # 80008910 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	256080e7          	jalr	598(ra) # 8000634c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	sll	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c7e50513          	add	a0,a0,-898 # 80021d80 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	add	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	add	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7ec48493          	add	s1,s1,2028 # 80008910 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	2ae080e7          	jalr	686(ra) # 800063dc <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7d450513          	add	a0,a0,2004 # 80008910 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	34a080e7          	jalr	842(ra) # 80006490 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	add	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	7a850513          	add	a0,a0,1960 # 80008910 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	320080e7          	jalr	800(ra) # 80006490 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <freemem_size>:

uint64
freemem_size(void)
{
    8000017a:	1101                	add	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	add	s0,sp,32
  acquire(&kmem.lock); // prevent race condition
    80000184:	00008497          	auipc	s1,0x8
    80000188:	78c48493          	add	s1,s1,1932 # 80008910 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	24e080e7          	jalr	590(ra) # 800063dc <acquire>

  uint64 size = 0;
  struct run *r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  while (r) {
    80000198:	c785                	beqz	a5,800001c0 <freemem_size+0x46>
  uint64 size = 0;
    8000019a:	4481                	li	s1,0
    size++;
    8000019c:	0485                	add	s1,s1,1
    r = r->next;
    8000019e:	639c                	ld	a5,0(a5)
  while (r) {
    800001a0:	fff5                	bnez	a5,8000019c <freemem_size+0x22>
  }
  
  release(&kmem.lock);
    800001a2:	00008517          	auipc	a0,0x8
    800001a6:	76e50513          	add	a0,a0,1902 # 80008910 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	2e6080e7          	jalr	742(ra) # 80006490 <release>

  return size * PGSIZE;
    800001b2:	00c49513          	sll	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	add	sp,sp,32
    800001be:	8082                	ret
  uint64 size = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <freemem_size+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	add	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	sll	a2,a2,0x20
    800001d0:	9201                	srl	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	add	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	add	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	add	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	sll	a3,a3,0x20
    800001f4:	9281                	srl	a3,a3,0x20
    800001f6:	0685                	add	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	add	a0,a0,1
    80000208:	0585                	add	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	add	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	add	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	sll	a2,a2,0x20
    8000022e:	9201                	srl	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	add	a1,a1,1
    80000238:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd281>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	feb79ae3          	bne	a5,a1,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	add	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	sll	a3,a2,0x20
    80000250:	9281                	srl	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addw	a5,a2,-1
    80000260:	1782                	sll	a5,a5,0x20
    80000262:	9381                	srl	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	add	a4,a4,-1
    8000026c:	16fd                	add	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fef71ae3          	bne	a4,a5,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	add	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	add	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	add	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addw	a2,a2,-1
    800002ac:	0505                	add	a0,a0,1
    800002ae:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a801                	j	800002c4 <strncmp+0x30>
    800002b6:	4501                	li	a0,0
    800002b8:	a031                	j	800002c4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800002ba:	00054503          	lbu	a0,0(a0)
    800002be:	0005c783          	lbu	a5,0(a1)
    800002c2:	9d1d                	subw	a0,a0,a5
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	add	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ca:	1141                	add	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d0:	87aa                	mv	a5,a0
    800002d2:	86b2                	mv	a3,a2
    800002d4:	367d                	addw	a2,a2,-1
    800002d6:	02d05563          	blez	a3,80000300 <strncpy+0x36>
    800002da:	0785                	add	a5,a5,1
    800002dc:	0005c703          	lbu	a4,0(a1)
    800002e0:	fee78fa3          	sb	a4,-1(a5)
    800002e4:	0585                	add	a1,a1,1
    800002e6:	f775                	bnez	a4,800002d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002e8:	873e                	mv	a4,a5
    800002ea:	9fb5                	addw	a5,a5,a3
    800002ec:	37fd                	addw	a5,a5,-1
    800002ee:	00c05963          	blez	a2,80000300 <strncpy+0x36>
    *s++ = 0;
    800002f2:	0705                	add	a4,a4,1
    800002f4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002f8:	40e786bb          	subw	a3,a5,a4
    800002fc:	fed04be3          	bgtz	a3,800002f2 <strncpy+0x28>
  return os;
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	add	sp,sp,16
    80000304:	8082                	ret

0000000080000306 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000306:	1141                	add	sp,sp,-16
    80000308:	e422                	sd	s0,8(sp)
    8000030a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000030c:	02c05363          	blez	a2,80000332 <safestrcpy+0x2c>
    80000310:	fff6069b          	addw	a3,a2,-1
    80000314:	1682                	sll	a3,a3,0x20
    80000316:	9281                	srl	a3,a3,0x20
    80000318:	96ae                	add	a3,a3,a1
    8000031a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000031c:	00d58963          	beq	a1,a3,8000032e <safestrcpy+0x28>
    80000320:	0585                	add	a1,a1,1
    80000322:	0785                	add	a5,a5,1
    80000324:	fff5c703          	lbu	a4,-1(a1)
    80000328:	fee78fa3          	sb	a4,-1(a5)
    8000032c:	fb65                	bnez	a4,8000031c <safestrcpy+0x16>
    ;
  *s = 0;
    8000032e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000332:	6422                	ld	s0,8(sp)
    80000334:	0141                	add	sp,sp,16
    80000336:	8082                	ret

0000000080000338 <strlen>:

int
strlen(const char *s)
{
    80000338:	1141                	add	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000033e:	00054783          	lbu	a5,0(a0)
    80000342:	cf91                	beqz	a5,8000035e <strlen+0x26>
    80000344:	0505                	add	a0,a0,1
    80000346:	87aa                	mv	a5,a0
    80000348:	86be                	mv	a3,a5
    8000034a:	0785                	add	a5,a5,1
    8000034c:	fff7c703          	lbu	a4,-1(a5)
    80000350:	ff65                	bnez	a4,80000348 <strlen+0x10>
    80000352:	40a6853b          	subw	a0,a3,a0
    80000356:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000358:	6422                	ld	s0,8(sp)
    8000035a:	0141                	add	sp,sp,16
    8000035c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000035e:	4501                	li	a0,0
    80000360:	bfe5                	j	80000358 <strlen+0x20>

0000000080000362 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000362:	1141                	add	sp,sp,-16
    80000364:	e406                	sd	ra,8(sp)
    80000366:	e022                	sd	s0,0(sp)
    80000368:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    8000036a:	00001097          	auipc	ra,0x1
    8000036e:	bba080e7          	jalr	-1094(ra) # 80000f24 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000372:	00008717          	auipc	a4,0x8
    80000376:	56e70713          	add	a4,a4,1390 # 800088e0 <started>
  if(cpuid() == 0){
    8000037a:	c139                	beqz	a0,800003c0 <main+0x5e>
    while(started == 0)
    8000037c:	431c                	lw	a5,0(a4)
    8000037e:	2781                	sext.w	a5,a5
    80000380:	dff5                	beqz	a5,8000037c <main+0x1a>
      ;
    __sync_synchronize();
    80000382:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000386:	00001097          	auipc	ra,0x1
    8000038a:	b9e080e7          	jalr	-1122(ra) # 80000f24 <cpuid>
    8000038e:	85aa                	mv	a1,a0
    80000390:	00008517          	auipc	a0,0x8
    80000394:	ca850513          	add	a0,a0,-856 # 80008038 <etext+0x38>
    80000398:	00006097          	auipc	ra,0x6
    8000039c:	b14080e7          	jalr	-1260(ra) # 80005eac <printf>
    kvminithart();    // turn on paging
    800003a0:	00000097          	auipc	ra,0x0
    800003a4:	0d8080e7          	jalr	216(ra) # 80000478 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003a8:	00002097          	auipc	ra,0x2
    800003ac:	8ce080e7          	jalr	-1842(ra) # 80001c76 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b0:	00005097          	auipc	ra,0x5
    800003b4:	f54080e7          	jalr	-172(ra) # 80005304 <plicinithart>
  }

  scheduler();        
    800003b8:	00001097          	auipc	ra,0x1
    800003bc:	094080e7          	jalr	148(ra) # 8000144c <scheduler>
    consoleinit();
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	9b2080e7          	jalr	-1614(ra) # 80005d72 <consoleinit>
    printfinit();
    800003c8:	00006097          	auipc	ra,0x6
    800003cc:	cec080e7          	jalr	-788(ra) # 800060b4 <printfinit>
    printf("\n");
    800003d0:	00008517          	auipc	a0,0x8
    800003d4:	c4850513          	add	a0,a0,-952 # 80008018 <etext+0x18>
    800003d8:	00006097          	auipc	ra,0x6
    800003dc:	ad4080e7          	jalr	-1324(ra) # 80005eac <printf>
    printf("xv6 kernel is booting\n");
    800003e0:	00008517          	auipc	a0,0x8
    800003e4:	c4050513          	add	a0,a0,-960 # 80008020 <etext+0x20>
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	ac4080e7          	jalr	-1340(ra) # 80005eac <printf>
    printf("\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c2850513          	add	a0,a0,-984 # 80008018 <etext+0x18>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	ab4080e7          	jalr	-1356(ra) # 80005eac <printf>
    kinit();         // physical page allocator
    80000400:	00000097          	auipc	ra,0x0
    80000404:	cde080e7          	jalr	-802(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	34a080e7          	jalr	842(ra) # 80000752 <kvminit>
    kvminithart();   // turn on paging
    80000410:	00000097          	auipc	ra,0x0
    80000414:	068080e7          	jalr	104(ra) # 80000478 <kvminithart>
    procinit();      // process table
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	a4a080e7          	jalr	-1462(ra) # 80000e62 <procinit>
    trapinit();      // trap vectors
    80000420:	00002097          	auipc	ra,0x2
    80000424:	82e080e7          	jalr	-2002(ra) # 80001c4e <trapinit>
    trapinithart();  // install kernel trap vector
    80000428:	00002097          	auipc	ra,0x2
    8000042c:	84e080e7          	jalr	-1970(ra) # 80001c76 <trapinithart>
    plicinit();      // set up interrupt controller
    80000430:	00005097          	auipc	ra,0x5
    80000434:	eba080e7          	jalr	-326(ra) # 800052ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	ecc080e7          	jalr	-308(ra) # 80005304 <plicinithart>
    binit();         // buffer cache
    80000440:	00002097          	auipc	ra,0x2
    80000444:	f8c080e7          	jalr	-116(ra) # 800023cc <binit>
    iinit();         // inode table
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	642080e7          	jalr	1602(ra) # 80002a8a <iinit>
    fileinit();      // file table
    80000450:	00003097          	auipc	ra,0x3
    80000454:	5f2080e7          	jalr	1522(ra) # 80003a42 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	fb4080e7          	jalr	-76(ra) # 8000540c <virtio_disk_init>
    userinit();      // first user process
    80000460:	00001097          	auipc	ra,0x1
    80000464:	dcc080e7          	jalr	-564(ra) # 8000122c <userinit>
    __sync_synchronize();
    80000468:	0ff0000f          	fence
    started = 1;
    8000046c:	4785                	li	a5,1
    8000046e:	00008717          	auipc	a4,0x8
    80000472:	46f72923          	sw	a5,1138(a4) # 800088e0 <started>
    80000476:	b789                	j	800003b8 <main+0x56>

0000000080000478 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000478:	1141                	add	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000047e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000482:	00008797          	auipc	a5,0x8
    80000486:	4667b783          	ld	a5,1126(a5) # 800088e8 <kernel_pagetable>
    8000048a:	83b1                	srl	a5,a5,0xc
    8000048c:	577d                	li	a4,-1
    8000048e:	177e                	sll	a4,a4,0x3f
    80000490:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000492:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000496:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000049a:	6422                	ld	s0,8(sp)
    8000049c:	0141                	add	sp,sp,16
    8000049e:	8082                	ret

00000000800004a0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a0:	7139                	add	sp,sp,-64
    800004a2:	fc06                	sd	ra,56(sp)
    800004a4:	f822                	sd	s0,48(sp)
    800004a6:	f426                	sd	s1,40(sp)
    800004a8:	f04a                	sd	s2,32(sp)
    800004aa:	ec4e                	sd	s3,24(sp)
    800004ac:	e852                	sd	s4,16(sp)
    800004ae:	e456                	sd	s5,8(sp)
    800004b0:	e05a                	sd	s6,0(sp)
    800004b2:	0080                	add	s0,sp,64
    800004b4:	84aa                	mv	s1,a0
    800004b6:	89ae                	mv	s3,a1
    800004b8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004ba:	57fd                	li	a5,-1
    800004bc:	83e9                	srl	a5,a5,0x1a
    800004be:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c2:	04b7f263          	bgeu	a5,a1,80000506 <walk+0x66>
    panic("walk");
    800004c6:	00008517          	auipc	a0,0x8
    800004ca:	b8a50513          	add	a0,a0,-1142 # 80008050 <etext+0x50>
    800004ce:	00006097          	auipc	ra,0x6
    800004d2:	994080e7          	jalr	-1644(ra) # 80005e62 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d6:	060a8663          	beqz	s5,80000542 <walk+0xa2>
    800004da:	00000097          	auipc	ra,0x0
    800004de:	c40080e7          	jalr	-960(ra) # 8000011a <kalloc>
    800004e2:	84aa                	mv	s1,a0
    800004e4:	c529                	beqz	a0,8000052e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e6:	6605                	lui	a2,0x1
    800004e8:	4581                	li	a1,0
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	cda080e7          	jalr	-806(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f2:	00c4d793          	srl	a5,s1,0xc
    800004f6:	07aa                	sll	a5,a5,0xa
    800004f8:	0017e793          	or	a5,a5,1
    800004fc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000500:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd277>
    80000502:	036a0063          	beq	s4,s6,80000522 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000506:	0149d933          	srl	s2,s3,s4
    8000050a:	1ff97913          	and	s2,s2,511
    8000050e:	090e                	sll	s2,s2,0x3
    80000510:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000512:	00093483          	ld	s1,0(s2)
    80000516:	0014f793          	and	a5,s1,1
    8000051a:	dfd5                	beqz	a5,800004d6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000051c:	80a9                	srl	s1,s1,0xa
    8000051e:	04b2                	sll	s1,s1,0xc
    80000520:	b7c5                	j	80000500 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000522:	00c9d513          	srl	a0,s3,0xc
    80000526:	1ff57513          	and	a0,a0,511
    8000052a:	050e                	sll	a0,a0,0x3
    8000052c:	9526                	add	a0,a0,s1
}
    8000052e:	70e2                	ld	ra,56(sp)
    80000530:	7442                	ld	s0,48(sp)
    80000532:	74a2                	ld	s1,40(sp)
    80000534:	7902                	ld	s2,32(sp)
    80000536:	69e2                	ld	s3,24(sp)
    80000538:	6a42                	ld	s4,16(sp)
    8000053a:	6aa2                	ld	s5,8(sp)
    8000053c:	6b02                	ld	s6,0(sp)
    8000053e:	6121                	add	sp,sp,64
    80000540:	8082                	ret
        return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7ed                	j	8000052e <walk+0x8e>

0000000080000546 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000546:	57fd                	li	a5,-1
    80000548:	83e9                	srl	a5,a5,0x1a
    8000054a:	00b7f463          	bgeu	a5,a1,80000552 <walkaddr+0xc>
    return 0;
    8000054e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000550:	8082                	ret
{
    80000552:	1141                	add	sp,sp,-16
    80000554:	e406                	sd	ra,8(sp)
    80000556:	e022                	sd	s0,0(sp)
    80000558:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000055a:	4601                	li	a2,0
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	f44080e7          	jalr	-188(ra) # 800004a0 <walk>
  if(pte == 0)
    80000564:	c105                	beqz	a0,80000584 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000566:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000568:	0117f693          	and	a3,a5,17
    8000056c:	4745                	li	a4,17
    return 0;
    8000056e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000570:	00e68663          	beq	a3,a4,8000057c <walkaddr+0x36>
}
    80000574:	60a2                	ld	ra,8(sp)
    80000576:	6402                	ld	s0,0(sp)
    80000578:	0141                	add	sp,sp,16
    8000057a:	8082                	ret
  pa = PTE2PA(*pte);
    8000057c:	83a9                	srl	a5,a5,0xa
    8000057e:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000582:	bfcd                	j	80000574 <walkaddr+0x2e>
    return 0;
    80000584:	4501                	li	a0,0
    80000586:	b7fd                	j	80000574 <walkaddr+0x2e>

0000000080000588 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000588:	715d                	add	sp,sp,-80
    8000058a:	e486                	sd	ra,72(sp)
    8000058c:	e0a2                	sd	s0,64(sp)
    8000058e:	fc26                	sd	s1,56(sp)
    80000590:	f84a                	sd	s2,48(sp)
    80000592:	f44e                	sd	s3,40(sp)
    80000594:	f052                	sd	s4,32(sp)
    80000596:	ec56                	sd	s5,24(sp)
    80000598:	e85a                	sd	s6,16(sp)
    8000059a:	e45e                	sd	s7,8(sp)
    8000059c:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000059e:	03459793          	sll	a5,a1,0x34
    800005a2:	e7b9                	bnez	a5,800005f0 <mappages+0x68>
    800005a4:	8aaa                	mv	s5,a0
    800005a6:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800005a8:	03461793          	sll	a5,a2,0x34
    800005ac:	ebb1                	bnez	a5,80000600 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    800005ae:	c22d                	beqz	a2,80000610 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800005b0:	77fd                	lui	a5,0xfffff
    800005b2:	963e                	add	a2,a2,a5
    800005b4:	00b609b3          	add	s3,a2,a1
  a = va;
    800005b8:	892e                	mv	s2,a1
    800005ba:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005be:	6b85                	lui	s7,0x1
    800005c0:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c4:	4605                	li	a2,1
    800005c6:	85ca                	mv	a1,s2
    800005c8:	8556                	mv	a0,s5
    800005ca:	00000097          	auipc	ra,0x0
    800005ce:	ed6080e7          	jalr	-298(ra) # 800004a0 <walk>
    800005d2:	cd39                	beqz	a0,80000630 <mappages+0xa8>
    if(*pte & PTE_V)
    800005d4:	611c                	ld	a5,0(a0)
    800005d6:	8b85                	and	a5,a5,1
    800005d8:	e7a1                	bnez	a5,80000620 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005da:	80b1                	srl	s1,s1,0xc
    800005dc:	04aa                	sll	s1,s1,0xa
    800005de:	0164e4b3          	or	s1,s1,s6
    800005e2:	0014e493          	or	s1,s1,1
    800005e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e8:	07390063          	beq	s2,s3,80000648 <mappages+0xc0>
    a += PGSIZE;
    800005ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	bfc9                	j	800005c0 <mappages+0x38>
    panic("mappages: va not aligned");
    800005f0:	00008517          	auipc	a0,0x8
    800005f4:	a6850513          	add	a0,a0,-1432 # 80008058 <etext+0x58>
    800005f8:	00006097          	auipc	ra,0x6
    800005fc:	86a080e7          	jalr	-1942(ra) # 80005e62 <panic>
    panic("mappages: size not aligned");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a7850513          	add	a0,a0,-1416 # 80008078 <etext+0x78>
    80000608:	00006097          	auipc	ra,0x6
    8000060c:	85a080e7          	jalr	-1958(ra) # 80005e62 <panic>
    panic("mappages: size");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a8850513          	add	a0,a0,-1400 # 80008098 <etext+0x98>
    80000618:	00006097          	auipc	ra,0x6
    8000061c:	84a080e7          	jalr	-1974(ra) # 80005e62 <panic>
      panic("mappages: remap");
    80000620:	00008517          	auipc	a0,0x8
    80000624:	a8850513          	add	a0,a0,-1400 # 800080a8 <etext+0xa8>
    80000628:	00006097          	auipc	ra,0x6
    8000062c:	83a080e7          	jalr	-1990(ra) # 80005e62 <panic>
      return -1;
    80000630:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000632:	60a6                	ld	ra,72(sp)
    80000634:	6406                	ld	s0,64(sp)
    80000636:	74e2                	ld	s1,56(sp)
    80000638:	7942                	ld	s2,48(sp)
    8000063a:	79a2                	ld	s3,40(sp)
    8000063c:	7a02                	ld	s4,32(sp)
    8000063e:	6ae2                	ld	s5,24(sp)
    80000640:	6b42                	ld	s6,16(sp)
    80000642:	6ba2                	ld	s7,8(sp)
    80000644:	6161                	add	sp,sp,80
    80000646:	8082                	ret
  return 0;
    80000648:	4501                	li	a0,0
    8000064a:	b7e5                	j	80000632 <mappages+0xaa>

000000008000064c <kvmmap>:
{
    8000064c:	1141                	add	sp,sp,-16
    8000064e:	e406                	sd	ra,8(sp)
    80000650:	e022                	sd	s0,0(sp)
    80000652:	0800                	add	s0,sp,16
    80000654:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000656:	86b2                	mv	a3,a2
    80000658:	863e                	mv	a2,a5
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f2e080e7          	jalr	-210(ra) # 80000588 <mappages>
    80000662:	e509                	bnez	a0,8000066c <kvmmap+0x20>
}
    80000664:	60a2                	ld	ra,8(sp)
    80000666:	6402                	ld	s0,0(sp)
    80000668:	0141                	add	sp,sp,16
    8000066a:	8082                	ret
    panic("kvmmap");
    8000066c:	00008517          	auipc	a0,0x8
    80000670:	a4c50513          	add	a0,a0,-1460 # 800080b8 <etext+0xb8>
    80000674:	00005097          	auipc	ra,0x5
    80000678:	7ee080e7          	jalr	2030(ra) # 80005e62 <panic>

000000008000067c <kvmmake>:
{
    8000067c:	1101                	add	sp,sp,-32
    8000067e:	ec06                	sd	ra,24(sp)
    80000680:	e822                	sd	s0,16(sp)
    80000682:	e426                	sd	s1,8(sp)
    80000684:	e04a                	sd	s2,0(sp)
    80000686:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000688:	00000097          	auipc	ra,0x0
    8000068c:	a92080e7          	jalr	-1390(ra) # 8000011a <kalloc>
    80000690:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000692:	6605                	lui	a2,0x1
    80000694:	4581                	li	a1,0
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	b2e080e7          	jalr	-1234(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	6685                	lui	a3,0x1
    800006a2:	10000637          	lui	a2,0x10000
    800006a6:	100005b7          	lui	a1,0x10000
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	fa0080e7          	jalr	-96(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006b4:	4719                	li	a4,6
    800006b6:	6685                	lui	a3,0x1
    800006b8:	10001637          	lui	a2,0x10001
    800006bc:	100015b7          	lui	a1,0x10001
    800006c0:	8526                	mv	a0,s1
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	f8a080e7          	jalr	-118(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006ca:	4719                	li	a4,6
    800006cc:	004006b7          	lui	a3,0x400
    800006d0:	0c000637          	lui	a2,0xc000
    800006d4:	0c0005b7          	lui	a1,0xc000
    800006d8:	8526                	mv	a0,s1
    800006da:	00000097          	auipc	ra,0x0
    800006de:	f72080e7          	jalr	-142(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006e2:	00008917          	auipc	s2,0x8
    800006e6:	91e90913          	add	s2,s2,-1762 # 80008000 <etext>
    800006ea:	4729                	li	a4,10
    800006ec:	80008697          	auipc	a3,0x80008
    800006f0:	91468693          	add	a3,a3,-1772 # 8000 <_entry-0x7fff8000>
    800006f4:	4605                	li	a2,1
    800006f6:	067e                	sll	a2,a2,0x1f
    800006f8:	85b2                	mv	a1,a2
    800006fa:	8526                	mv	a0,s1
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	f50080e7          	jalr	-176(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000704:	46c5                	li	a3,17
    80000706:	06ee                	sll	a3,a3,0x1b
    80000708:	4719                	li	a4,6
    8000070a:	412686b3          	sub	a3,a3,s2
    8000070e:	864a                	mv	a2,s2
    80000710:	85ca                	mv	a1,s2
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f38080e7          	jalr	-200(ra) # 8000064c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000071c:	4729                	li	a4,10
    8000071e:	6685                	lui	a3,0x1
    80000720:	00007617          	auipc	a2,0x7
    80000724:	8e060613          	add	a2,a2,-1824 # 80007000 <_trampoline>
    80000728:	040005b7          	lui	a1,0x4000
    8000072c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000072e:	05b2                	sll	a1,a1,0xc
    80000730:	8526                	mv	a0,s1
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f1a080e7          	jalr	-230(ra) # 8000064c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000073a:	8526                	mv	a0,s1
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	682080e7          	jalr	1666(ra) # 80000dbe <proc_mapstacks>
}
    80000744:	8526                	mv	a0,s1
    80000746:	60e2                	ld	ra,24(sp)
    80000748:	6442                	ld	s0,16(sp)
    8000074a:	64a2                	ld	s1,8(sp)
    8000074c:	6902                	ld	s2,0(sp)
    8000074e:	6105                	add	sp,sp,32
    80000750:	8082                	ret

0000000080000752 <kvminit>:
{
    80000752:	1141                	add	sp,sp,-16
    80000754:	e406                	sd	ra,8(sp)
    80000756:	e022                	sd	s0,0(sp)
    80000758:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	f22080e7          	jalr	-222(ra) # 8000067c <kvmmake>
    80000762:	00008797          	auipc	a5,0x8
    80000766:	18a7b323          	sd	a0,390(a5) # 800088e8 <kernel_pagetable>
}
    8000076a:	60a2                	ld	ra,8(sp)
    8000076c:	6402                	ld	s0,0(sp)
    8000076e:	0141                	add	sp,sp,16
    80000770:	8082                	ret

0000000080000772 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000772:	715d                	add	sp,sp,-80
    80000774:	e486                	sd	ra,72(sp)
    80000776:	e0a2                	sd	s0,64(sp)
    80000778:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000077a:	03459793          	sll	a5,a1,0x34
    8000077e:	e39d                	bnez	a5,800007a4 <uvmunmap+0x32>
    80000780:	f84a                	sd	s2,48(sp)
    80000782:	f44e                	sd	s3,40(sp)
    80000784:	f052                	sd	s4,32(sp)
    80000786:	ec56                	sd	s5,24(sp)
    80000788:	e85a                	sd	s6,16(sp)
    8000078a:	e45e                	sd	s7,8(sp)
    8000078c:	8a2a                	mv	s4,a0
    8000078e:	892e                	mv	s2,a1
    80000790:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	0632                	sll	a2,a2,0xc
    80000794:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000798:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000079a:	6b05                	lui	s6,0x1
    8000079c:	0935fb63          	bgeu	a1,s3,80000832 <uvmunmap+0xc0>
    800007a0:	fc26                	sd	s1,56(sp)
    800007a2:	a8a9                	j	800007fc <uvmunmap+0x8a>
    800007a4:	fc26                	sd	s1,56(sp)
    800007a6:	f84a                	sd	s2,48(sp)
    800007a8:	f44e                	sd	s3,40(sp)
    800007aa:	f052                	sd	s4,32(sp)
    800007ac:	ec56                	sd	s5,24(sp)
    800007ae:	e85a                	sd	s6,16(sp)
    800007b0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800007b2:	00008517          	auipc	a0,0x8
    800007b6:	90e50513          	add	a0,a0,-1778 # 800080c0 <etext+0xc0>
    800007ba:	00005097          	auipc	ra,0x5
    800007be:	6a8080e7          	jalr	1704(ra) # 80005e62 <panic>
      panic("uvmunmap: walk");
    800007c2:	00008517          	auipc	a0,0x8
    800007c6:	91650513          	add	a0,a0,-1770 # 800080d8 <etext+0xd8>
    800007ca:	00005097          	auipc	ra,0x5
    800007ce:	698080e7          	jalr	1688(ra) # 80005e62 <panic>
      panic("uvmunmap: not mapped");
    800007d2:	00008517          	auipc	a0,0x8
    800007d6:	91650513          	add	a0,a0,-1770 # 800080e8 <etext+0xe8>
    800007da:	00005097          	auipc	ra,0x5
    800007de:	688080e7          	jalr	1672(ra) # 80005e62 <panic>
      panic("uvmunmap: not a leaf");
    800007e2:	00008517          	auipc	a0,0x8
    800007e6:	91e50513          	add	a0,a0,-1762 # 80008100 <etext+0x100>
    800007ea:	00005097          	auipc	ra,0x5
    800007ee:	678080e7          	jalr	1656(ra) # 80005e62 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f6:	995a                	add	s2,s2,s6
    800007f8:	03397c63          	bgeu	s2,s3,80000830 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007fc:	4601                	li	a2,0
    800007fe:	85ca                	mv	a1,s2
    80000800:	8552                	mv	a0,s4
    80000802:	00000097          	auipc	ra,0x0
    80000806:	c9e080e7          	jalr	-866(ra) # 800004a0 <walk>
    8000080a:	84aa                	mv	s1,a0
    8000080c:	d95d                	beqz	a0,800007c2 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000080e:	6108                	ld	a0,0(a0)
    80000810:	00157793          	and	a5,a0,1
    80000814:	dfdd                	beqz	a5,800007d2 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000816:	3ff57793          	and	a5,a0,1023
    8000081a:	fd7784e3          	beq	a5,s7,800007e2 <uvmunmap+0x70>
    if(do_free){
    8000081e:	fc0a8ae3          	beqz	s5,800007f2 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000822:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80000824:	0532                	sll	a0,a0,0xc
    80000826:	fffff097          	auipc	ra,0xfffff
    8000082a:	7f6080e7          	jalr	2038(ra) # 8000001c <kfree>
    8000082e:	b7d1                	j	800007f2 <uvmunmap+0x80>
    80000830:	74e2                	ld	s1,56(sp)
    80000832:	7942                	ld	s2,48(sp)
    80000834:	79a2                	ld	s3,40(sp)
    80000836:	7a02                	ld	s4,32(sp)
    80000838:	6ae2                	ld	s5,24(sp)
    8000083a:	6b42                	ld	s6,16(sp)
    8000083c:	6ba2                	ld	s7,8(sp)
  }
}
    8000083e:	60a6                	ld	ra,72(sp)
    80000840:	6406                	ld	s0,64(sp)
    80000842:	6161                	add	sp,sp,80
    80000844:	8082                	ret

0000000080000846 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000846:	1101                	add	sp,sp,-32
    80000848:	ec06                	sd	ra,24(sp)
    8000084a:	e822                	sd	s0,16(sp)
    8000084c:	e426                	sd	s1,8(sp)
    8000084e:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000850:	00000097          	auipc	ra,0x0
    80000854:	8ca080e7          	jalr	-1846(ra) # 8000011a <kalloc>
    80000858:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000085a:	c519                	beqz	a0,80000868 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000085c:	6605                	lui	a2,0x1
    8000085e:	4581                	li	a1,0
    80000860:	00000097          	auipc	ra,0x0
    80000864:	964080e7          	jalr	-1692(ra) # 800001c4 <memset>
  return pagetable;
}
    80000868:	8526                	mv	a0,s1
    8000086a:	60e2                	ld	ra,24(sp)
    8000086c:	6442                	ld	s0,16(sp)
    8000086e:	64a2                	ld	s1,8(sp)
    80000870:	6105                	add	sp,sp,32
    80000872:	8082                	ret

0000000080000874 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000874:	7179                	add	sp,sp,-48
    80000876:	f406                	sd	ra,40(sp)
    80000878:	f022                	sd	s0,32(sp)
    8000087a:	ec26                	sd	s1,24(sp)
    8000087c:	e84a                	sd	s2,16(sp)
    8000087e:	e44e                	sd	s3,8(sp)
    80000880:	e052                	sd	s4,0(sp)
    80000882:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000884:	6785                	lui	a5,0x1
    80000886:	04f67863          	bgeu	a2,a5,800008d6 <uvmfirst+0x62>
    8000088a:	8a2a                	mv	s4,a0
    8000088c:	89ae                	mv	s3,a1
    8000088e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000890:	00000097          	auipc	ra,0x0
    80000894:	88a080e7          	jalr	-1910(ra) # 8000011a <kalloc>
    80000898:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000089a:	6605                	lui	a2,0x1
    8000089c:	4581                	li	a1,0
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	926080e7          	jalr	-1754(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008a6:	4779                	li	a4,30
    800008a8:	86ca                	mv	a3,s2
    800008aa:	6605                	lui	a2,0x1
    800008ac:	4581                	li	a1,0
    800008ae:	8552                	mv	a0,s4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	cd8080e7          	jalr	-808(ra) # 80000588 <mappages>
  memmove(mem, src, sz);
    800008b8:	8626                	mv	a2,s1
    800008ba:	85ce                	mv	a1,s3
    800008bc:	854a                	mv	a0,s2
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	962080e7          	jalr	-1694(ra) # 80000220 <memmove>
}
    800008c6:	70a2                	ld	ra,40(sp)
    800008c8:	7402                	ld	s0,32(sp)
    800008ca:	64e2                	ld	s1,24(sp)
    800008cc:	6942                	ld	s2,16(sp)
    800008ce:	69a2                	ld	s3,8(sp)
    800008d0:	6a02                	ld	s4,0(sp)
    800008d2:	6145                	add	sp,sp,48
    800008d4:	8082                	ret
    panic("uvmfirst: more than a page");
    800008d6:	00008517          	auipc	a0,0x8
    800008da:	84250513          	add	a0,a0,-1982 # 80008118 <etext+0x118>
    800008de:	00005097          	auipc	ra,0x5
    800008e2:	584080e7          	jalr	1412(ra) # 80005e62 <panic>

00000000800008e6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008e6:	1101                	add	sp,sp,-32
    800008e8:	ec06                	sd	ra,24(sp)
    800008ea:	e822                	sd	s0,16(sp)
    800008ec:	e426                	sd	s1,8(sp)
    800008ee:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008f0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008f2:	00b67d63          	bgeu	a2,a1,8000090c <uvmdealloc+0x26>
    800008f6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008f8:	6785                	lui	a5,0x1
    800008fa:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fc:	00f60733          	add	a4,a2,a5
    80000900:	76fd                	lui	a3,0xfffff
    80000902:	8f75                	and	a4,a4,a3
    80000904:	97ae                	add	a5,a5,a1
    80000906:	8ff5                	and	a5,a5,a3
    80000908:	00f76863          	bltu	a4,a5,80000918 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000090c:	8526                	mv	a0,s1
    8000090e:	60e2                	ld	ra,24(sp)
    80000910:	6442                	ld	s0,16(sp)
    80000912:	64a2                	ld	s1,8(sp)
    80000914:	6105                	add	sp,sp,32
    80000916:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000918:	8f99                	sub	a5,a5,a4
    8000091a:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000091c:	4685                	li	a3,1
    8000091e:	0007861b          	sext.w	a2,a5
    80000922:	85ba                	mv	a1,a4
    80000924:	00000097          	auipc	ra,0x0
    80000928:	e4e080e7          	jalr	-434(ra) # 80000772 <uvmunmap>
    8000092c:	b7c5                	j	8000090c <uvmdealloc+0x26>

000000008000092e <uvmalloc>:
  if(newsz < oldsz)
    8000092e:	0ab66b63          	bltu	a2,a1,800009e4 <uvmalloc+0xb6>
{
    80000932:	7139                	add	sp,sp,-64
    80000934:	fc06                	sd	ra,56(sp)
    80000936:	f822                	sd	s0,48(sp)
    80000938:	ec4e                	sd	s3,24(sp)
    8000093a:	e852                	sd	s4,16(sp)
    8000093c:	e456                	sd	s5,8(sp)
    8000093e:	0080                	add	s0,sp,64
    80000940:	8aaa                	mv	s5,a0
    80000942:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000944:	6785                	lui	a5,0x1
    80000946:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000948:	95be                	add	a1,a1,a5
    8000094a:	77fd                	lui	a5,0xfffff
    8000094c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000950:	08c9fc63          	bgeu	s3,a2,800009e8 <uvmalloc+0xba>
    80000954:	f426                	sd	s1,40(sp)
    80000956:	f04a                	sd	s2,32(sp)
    80000958:	e05a                	sd	s6,0(sp)
    8000095a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000095c:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80000960:	fffff097          	auipc	ra,0xfffff
    80000964:	7ba080e7          	jalr	1978(ra) # 8000011a <kalloc>
    80000968:	84aa                	mv	s1,a0
    if(mem == 0){
    8000096a:	c915                	beqz	a0,8000099e <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    8000096c:	6605                	lui	a2,0x1
    8000096e:	4581                	li	a1,0
    80000970:	00000097          	auipc	ra,0x0
    80000974:	854080e7          	jalr	-1964(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000978:	875a                	mv	a4,s6
    8000097a:	86a6                	mv	a3,s1
    8000097c:	6605                	lui	a2,0x1
    8000097e:	85ca                	mv	a1,s2
    80000980:	8556                	mv	a0,s5
    80000982:	00000097          	auipc	ra,0x0
    80000986:	c06080e7          	jalr	-1018(ra) # 80000588 <mappages>
    8000098a:	ed05                	bnez	a0,800009c2 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000098c:	6785                	lui	a5,0x1
    8000098e:	993e                	add	s2,s2,a5
    80000990:	fd4968e3          	bltu	s2,s4,80000960 <uvmalloc+0x32>
  return newsz;
    80000994:	8552                	mv	a0,s4
    80000996:	74a2                	ld	s1,40(sp)
    80000998:	7902                	ld	s2,32(sp)
    8000099a:	6b02                	ld	s6,0(sp)
    8000099c:	a821                	j	800009b4 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    8000099e:	864e                	mv	a2,s3
    800009a0:	85ca                	mv	a1,s2
    800009a2:	8556                	mv	a0,s5
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	f42080e7          	jalr	-190(ra) # 800008e6 <uvmdealloc>
      return 0;
    800009ac:	4501                	li	a0,0
    800009ae:	74a2                	ld	s1,40(sp)
    800009b0:	7902                	ld	s2,32(sp)
    800009b2:	6b02                	ld	s6,0(sp)
}
    800009b4:	70e2                	ld	ra,56(sp)
    800009b6:	7442                	ld	s0,48(sp)
    800009b8:	69e2                	ld	s3,24(sp)
    800009ba:	6a42                	ld	s4,16(sp)
    800009bc:	6aa2                	ld	s5,8(sp)
    800009be:	6121                	add	sp,sp,64
    800009c0:	8082                	ret
      kfree(mem);
    800009c2:	8526                	mv	a0,s1
    800009c4:	fffff097          	auipc	ra,0xfffff
    800009c8:	658080e7          	jalr	1624(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009cc:	864e                	mv	a2,s3
    800009ce:	85ca                	mv	a1,s2
    800009d0:	8556                	mv	a0,s5
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	f14080e7          	jalr	-236(ra) # 800008e6 <uvmdealloc>
      return 0;
    800009da:	4501                	li	a0,0
    800009dc:	74a2                	ld	s1,40(sp)
    800009de:	7902                	ld	s2,32(sp)
    800009e0:	6b02                	ld	s6,0(sp)
    800009e2:	bfc9                	j	800009b4 <uvmalloc+0x86>
    return oldsz;
    800009e4:	852e                	mv	a0,a1
}
    800009e6:	8082                	ret
  return newsz;
    800009e8:	8532                	mv	a0,a2
    800009ea:	b7e9                	j	800009b4 <uvmalloc+0x86>

00000000800009ec <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ec:	7179                	add	sp,sp,-48
    800009ee:	f406                	sd	ra,40(sp)
    800009f0:	f022                	sd	s0,32(sp)
    800009f2:	ec26                	sd	s1,24(sp)
    800009f4:	e84a                	sd	s2,16(sp)
    800009f6:	e44e                	sd	s3,8(sp)
    800009f8:	e052                	sd	s4,0(sp)
    800009fa:	1800                	add	s0,sp,48
    800009fc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009fe:	84aa                	mv	s1,a0
    80000a00:	6905                	lui	s2,0x1
    80000a02:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a04:	4985                	li	s3,1
    80000a06:	a829                	j	80000a20 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a08:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a0a:	00c79513          	sll	a0,a5,0xc
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	fde080e7          	jalr	-34(ra) # 800009ec <freewalk>
      pagetable[i] = 0;
    80000a16:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a1a:	04a1                	add	s1,s1,8
    80000a1c:	03248163          	beq	s1,s2,80000a3e <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a20:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a22:	00f7f713          	and	a4,a5,15
    80000a26:	ff3701e3          	beq	a4,s3,80000a08 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a2a:	8b85                	and	a5,a5,1
    80000a2c:	d7fd                	beqz	a5,80000a1a <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a2e:	00007517          	auipc	a0,0x7
    80000a32:	70a50513          	add	a0,a0,1802 # 80008138 <etext+0x138>
    80000a36:	00005097          	auipc	ra,0x5
    80000a3a:	42c080e7          	jalr	1068(ra) # 80005e62 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a3e:	8552                	mv	a0,s4
    80000a40:	fffff097          	auipc	ra,0xfffff
    80000a44:	5dc080e7          	jalr	1500(ra) # 8000001c <kfree>
}
    80000a48:	70a2                	ld	ra,40(sp)
    80000a4a:	7402                	ld	s0,32(sp)
    80000a4c:	64e2                	ld	s1,24(sp)
    80000a4e:	6942                	ld	s2,16(sp)
    80000a50:	69a2                	ld	s3,8(sp)
    80000a52:	6a02                	ld	s4,0(sp)
    80000a54:	6145                	add	sp,sp,48
    80000a56:	8082                	ret

0000000080000a58 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a58:	1101                	add	sp,sp,-32
    80000a5a:	ec06                	sd	ra,24(sp)
    80000a5c:	e822                	sd	s0,16(sp)
    80000a5e:	e426                	sd	s1,8(sp)
    80000a60:	1000                	add	s0,sp,32
    80000a62:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a64:	e999                	bnez	a1,80000a7a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a66:	8526                	mv	a0,s1
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	f84080e7          	jalr	-124(ra) # 800009ec <freewalk>
}
    80000a70:	60e2                	ld	ra,24(sp)
    80000a72:	6442                	ld	s0,16(sp)
    80000a74:	64a2                	ld	s1,8(sp)
    80000a76:	6105                	add	sp,sp,32
    80000a78:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a7e:	95be                	add	a1,a1,a5
    80000a80:	4685                	li	a3,1
    80000a82:	00c5d613          	srl	a2,a1,0xc
    80000a86:	4581                	li	a1,0
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	cea080e7          	jalr	-790(ra) # 80000772 <uvmunmap>
    80000a90:	bfd9                	j	80000a66 <uvmfree+0xe>

0000000080000a92 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a92:	c679                	beqz	a2,80000b60 <uvmcopy+0xce>
{
    80000a94:	715d                	add	sp,sp,-80
    80000a96:	e486                	sd	ra,72(sp)
    80000a98:	e0a2                	sd	s0,64(sp)
    80000a9a:	fc26                	sd	s1,56(sp)
    80000a9c:	f84a                	sd	s2,48(sp)
    80000a9e:	f44e                	sd	s3,40(sp)
    80000aa0:	f052                	sd	s4,32(sp)
    80000aa2:	ec56                	sd	s5,24(sp)
    80000aa4:	e85a                	sd	s6,16(sp)
    80000aa6:	e45e                	sd	s7,8(sp)
    80000aa8:	0880                	add	s0,sp,80
    80000aaa:	8b2a                	mv	s6,a0
    80000aac:	8aae                	mv	s5,a1
    80000aae:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000ab0:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000ab2:	4601                	li	a2,0
    80000ab4:	85ce                	mv	a1,s3
    80000ab6:	855a                	mv	a0,s6
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	9e8080e7          	jalr	-1560(ra) # 800004a0 <walk>
    80000ac0:	c531                	beqz	a0,80000b0c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000ac2:	6118                	ld	a4,0(a0)
    80000ac4:	00177793          	and	a5,a4,1
    80000ac8:	cbb1                	beqz	a5,80000b1c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aca:	00a75593          	srl	a1,a4,0xa
    80000ace:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000ad2:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000ad6:	fffff097          	auipc	ra,0xfffff
    80000ada:	644080e7          	jalr	1604(ra) # 8000011a <kalloc>
    80000ade:	892a                	mv	s2,a0
    80000ae0:	c939                	beqz	a0,80000b36 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000ae2:	6605                	lui	a2,0x1
    80000ae4:	85de                	mv	a1,s7
    80000ae6:	fffff097          	auipc	ra,0xfffff
    80000aea:	73a080e7          	jalr	1850(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aee:	8726                	mv	a4,s1
    80000af0:	86ca                	mv	a3,s2
    80000af2:	6605                	lui	a2,0x1
    80000af4:	85ce                	mv	a1,s3
    80000af6:	8556                	mv	a0,s5
    80000af8:	00000097          	auipc	ra,0x0
    80000afc:	a90080e7          	jalr	-1392(ra) # 80000588 <mappages>
    80000b00:	e515                	bnez	a0,80000b2c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b02:	6785                	lui	a5,0x1
    80000b04:	99be                	add	s3,s3,a5
    80000b06:	fb49e6e3          	bltu	s3,s4,80000ab2 <uvmcopy+0x20>
    80000b0a:	a081                	j	80000b4a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b0c:	00007517          	auipc	a0,0x7
    80000b10:	63c50513          	add	a0,a0,1596 # 80008148 <etext+0x148>
    80000b14:	00005097          	auipc	ra,0x5
    80000b18:	34e080e7          	jalr	846(ra) # 80005e62 <panic>
      panic("uvmcopy: page not present");
    80000b1c:	00007517          	auipc	a0,0x7
    80000b20:	64c50513          	add	a0,a0,1612 # 80008168 <etext+0x168>
    80000b24:	00005097          	auipc	ra,0x5
    80000b28:	33e080e7          	jalr	830(ra) # 80005e62 <panic>
      kfree(mem);
    80000b2c:	854a                	mv	a0,s2
    80000b2e:	fffff097          	auipc	ra,0xfffff
    80000b32:	4ee080e7          	jalr	1262(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b36:	4685                	li	a3,1
    80000b38:	00c9d613          	srl	a2,s3,0xc
    80000b3c:	4581                	li	a1,0
    80000b3e:	8556                	mv	a0,s5
    80000b40:	00000097          	auipc	ra,0x0
    80000b44:	c32080e7          	jalr	-974(ra) # 80000772 <uvmunmap>
  return -1;
    80000b48:	557d                	li	a0,-1
}
    80000b4a:	60a6                	ld	ra,72(sp)
    80000b4c:	6406                	ld	s0,64(sp)
    80000b4e:	74e2                	ld	s1,56(sp)
    80000b50:	7942                	ld	s2,48(sp)
    80000b52:	79a2                	ld	s3,40(sp)
    80000b54:	7a02                	ld	s4,32(sp)
    80000b56:	6ae2                	ld	s5,24(sp)
    80000b58:	6b42                	ld	s6,16(sp)
    80000b5a:	6ba2                	ld	s7,8(sp)
    80000b5c:	6161                	add	sp,sp,80
    80000b5e:	8082                	ret
  return 0;
    80000b60:	4501                	li	a0,0
}
    80000b62:	8082                	ret

0000000080000b64 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b64:	1141                	add	sp,sp,-16
    80000b66:	e406                	sd	ra,8(sp)
    80000b68:	e022                	sd	s0,0(sp)
    80000b6a:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b6c:	4601                	li	a2,0
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	932080e7          	jalr	-1742(ra) # 800004a0 <walk>
  if(pte == 0)
    80000b76:	c901                	beqz	a0,80000b86 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b78:	611c                	ld	a5,0(a0)
    80000b7a:	9bbd                	and	a5,a5,-17
    80000b7c:	e11c                	sd	a5,0(a0)
}
    80000b7e:	60a2                	ld	ra,8(sp)
    80000b80:	6402                	ld	s0,0(sp)
    80000b82:	0141                	add	sp,sp,16
    80000b84:	8082                	ret
    panic("uvmclear");
    80000b86:	00007517          	auipc	a0,0x7
    80000b8a:	60250513          	add	a0,a0,1538 # 80008188 <etext+0x188>
    80000b8e:	00005097          	auipc	ra,0x5
    80000b92:	2d4080e7          	jalr	724(ra) # 80005e62 <panic>

0000000080000b96 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b96:	ced1                	beqz	a3,80000c32 <copyout+0x9c>
{
    80000b98:	711d                	add	sp,sp,-96
    80000b9a:	ec86                	sd	ra,88(sp)
    80000b9c:	e8a2                	sd	s0,80(sp)
    80000b9e:	e4a6                	sd	s1,72(sp)
    80000ba0:	fc4e                	sd	s3,56(sp)
    80000ba2:	f456                	sd	s5,40(sp)
    80000ba4:	f05a                	sd	s6,32(sp)
    80000ba6:	ec5e                	sd	s7,24(sp)
    80000ba8:	1080                	add	s0,sp,96
    80000baa:	8baa                	mv	s7,a0
    80000bac:	8aae                	mv	s5,a1
    80000bae:	8b32                	mv	s6,a2
    80000bb0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000bb2:	74fd                	lui	s1,0xfffff
    80000bb4:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000bb6:	57fd                	li	a5,-1
    80000bb8:	83e9                	srl	a5,a5,0x1a
    80000bba:	0697ee63          	bltu	a5,s1,80000c36 <copyout+0xa0>
    80000bbe:	e0ca                	sd	s2,64(sp)
    80000bc0:	f852                	sd	s4,48(sp)
    80000bc2:	e862                	sd	s8,16(sp)
    80000bc4:	e466                	sd	s9,8(sp)
    80000bc6:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bc8:	4cd5                	li	s9,21
    80000bca:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000bcc:	8c3e                	mv	s8,a5
    80000bce:	a035                	j	80000bfa <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000bd0:	83a9                	srl	a5,a5,0xa
    80000bd2:	07b2                	sll	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bd4:	409a8533          	sub	a0,s5,s1
    80000bd8:	0009061b          	sext.w	a2,s2
    80000bdc:	85da                	mv	a1,s6
    80000bde:	953e                	add	a0,a0,a5
    80000be0:	fffff097          	auipc	ra,0xfffff
    80000be4:	640080e7          	jalr	1600(ra) # 80000220 <memmove>

    len -= n;
    80000be8:	412989b3          	sub	s3,s3,s2
    src += n;
    80000bec:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000bee:	02098b63          	beqz	s3,80000c24 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000bf2:	054c6463          	bltu	s8,s4,80000c3a <copyout+0xa4>
    80000bf6:	84d2                	mv	s1,s4
    80000bf8:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bfa:	4601                	li	a2,0
    80000bfc:	85a6                	mv	a1,s1
    80000bfe:	855e                	mv	a0,s7
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	8a0080e7          	jalr	-1888(ra) # 800004a0 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000c08:	c121                	beqz	a0,80000c48 <copyout+0xb2>
    80000c0a:	611c                	ld	a5,0(a0)
    80000c0c:	0157f713          	and	a4,a5,21
    80000c10:	05971b63          	bne	a4,s9,80000c66 <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000c14:	01a48a33          	add	s4,s1,s10
    80000c18:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000c1c:	fb29fae3          	bgeu	s3,s2,80000bd0 <copyout+0x3a>
    80000c20:	894e                	mv	s2,s3
    80000c22:	b77d                	j	80000bd0 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000c24:	4501                	li	a0,0
    80000c26:	6906                	ld	s2,64(sp)
    80000c28:	7a42                	ld	s4,48(sp)
    80000c2a:	6c42                	ld	s8,16(sp)
    80000c2c:	6ca2                	ld	s9,8(sp)
    80000c2e:	6d02                	ld	s10,0(sp)
    80000c30:	a015                	j	80000c54 <copyout+0xbe>
    80000c32:	4501                	li	a0,0
}
    80000c34:	8082                	ret
      return -1;
    80000c36:	557d                	li	a0,-1
    80000c38:	a831                	j	80000c54 <copyout+0xbe>
    80000c3a:	557d                	li	a0,-1
    80000c3c:	6906                	ld	s2,64(sp)
    80000c3e:	7a42                	ld	s4,48(sp)
    80000c40:	6c42                	ld	s8,16(sp)
    80000c42:	6ca2                	ld	s9,8(sp)
    80000c44:	6d02                	ld	s10,0(sp)
    80000c46:	a039                	j	80000c54 <copyout+0xbe>
      return -1;
    80000c48:	557d                	li	a0,-1
    80000c4a:	6906                	ld	s2,64(sp)
    80000c4c:	7a42                	ld	s4,48(sp)
    80000c4e:	6c42                	ld	s8,16(sp)
    80000c50:	6ca2                	ld	s9,8(sp)
    80000c52:	6d02                	ld	s10,0(sp)
}
    80000c54:	60e6                	ld	ra,88(sp)
    80000c56:	6446                	ld	s0,80(sp)
    80000c58:	64a6                	ld	s1,72(sp)
    80000c5a:	79e2                	ld	s3,56(sp)
    80000c5c:	7aa2                	ld	s5,40(sp)
    80000c5e:	7b02                	ld	s6,32(sp)
    80000c60:	6be2                	ld	s7,24(sp)
    80000c62:	6125                	add	sp,sp,96
    80000c64:	8082                	ret
      return -1;
    80000c66:	557d                	li	a0,-1
    80000c68:	6906                	ld	s2,64(sp)
    80000c6a:	7a42                	ld	s4,48(sp)
    80000c6c:	6c42                	ld	s8,16(sp)
    80000c6e:	6ca2                	ld	s9,8(sp)
    80000c70:	6d02                	ld	s10,0(sp)
    80000c72:	b7cd                	j	80000c54 <copyout+0xbe>

0000000080000c74 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c74:	caa5                	beqz	a3,80000ce4 <copyin+0x70>
{
    80000c76:	715d                	add	sp,sp,-80
    80000c78:	e486                	sd	ra,72(sp)
    80000c7a:	e0a2                	sd	s0,64(sp)
    80000c7c:	fc26                	sd	s1,56(sp)
    80000c7e:	f84a                	sd	s2,48(sp)
    80000c80:	f44e                	sd	s3,40(sp)
    80000c82:	f052                	sd	s4,32(sp)
    80000c84:	ec56                	sd	s5,24(sp)
    80000c86:	e85a                	sd	s6,16(sp)
    80000c88:	e45e                	sd	s7,8(sp)
    80000c8a:	e062                	sd	s8,0(sp)
    80000c8c:	0880                	add	s0,sp,80
    80000c8e:	8b2a                	mv	s6,a0
    80000c90:	8a2e                	mv	s4,a1
    80000c92:	8c32                	mv	s8,a2
    80000c94:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c96:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c98:	6a85                	lui	s5,0x1
    80000c9a:	a01d                	j	80000cc0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c9c:	018505b3          	add	a1,a0,s8
    80000ca0:	0004861b          	sext.w	a2,s1
    80000ca4:	412585b3          	sub	a1,a1,s2
    80000ca8:	8552                	mv	a0,s4
    80000caa:	fffff097          	auipc	ra,0xfffff
    80000cae:	576080e7          	jalr	1398(ra) # 80000220 <memmove>

    len -= n;
    80000cb2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cb6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cb8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cbc:	02098263          	beqz	s3,80000ce0 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cc0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cc4:	85ca                	mv	a1,s2
    80000cc6:	855a                	mv	a0,s6
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	87e080e7          	jalr	-1922(ra) # 80000546 <walkaddr>
    if(pa0 == 0)
    80000cd0:	cd01                	beqz	a0,80000ce8 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cd2:	418904b3          	sub	s1,s2,s8
    80000cd6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cd8:	fc99f2e3          	bgeu	s3,s1,80000c9c <copyin+0x28>
    80000cdc:	84ce                	mv	s1,s3
    80000cde:	bf7d                	j	80000c9c <copyin+0x28>
  }
  return 0;
    80000ce0:	4501                	li	a0,0
    80000ce2:	a021                	j	80000cea <copyin+0x76>
    80000ce4:	4501                	li	a0,0
}
    80000ce6:	8082                	ret
      return -1;
    80000ce8:	557d                	li	a0,-1
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6c02                	ld	s8,0(sp)
    80000cfe:	6161                	add	sp,sp,80
    80000d00:	8082                	ret

0000000080000d02 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d02:	cacd                	beqz	a3,80000db4 <copyinstr+0xb2>
{
    80000d04:	715d                	add	sp,sp,-80
    80000d06:	e486                	sd	ra,72(sp)
    80000d08:	e0a2                	sd	s0,64(sp)
    80000d0a:	fc26                	sd	s1,56(sp)
    80000d0c:	f84a                	sd	s2,48(sp)
    80000d0e:	f44e                	sd	s3,40(sp)
    80000d10:	f052                	sd	s4,32(sp)
    80000d12:	ec56                	sd	s5,24(sp)
    80000d14:	e85a                	sd	s6,16(sp)
    80000d16:	e45e                	sd	s7,8(sp)
    80000d18:	0880                	add	s0,sp,80
    80000d1a:	8a2a                	mv	s4,a0
    80000d1c:	8b2e                	mv	s6,a1
    80000d1e:	8bb2                	mv	s7,a2
    80000d20:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d22:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d24:	6985                	lui	s3,0x1
    80000d26:	a825                	j	80000d5e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d28:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d2c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d2e:	37fd                	addw	a5,a5,-1
    80000d30:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d34:	60a6                	ld	ra,72(sp)
    80000d36:	6406                	ld	s0,64(sp)
    80000d38:	74e2                	ld	s1,56(sp)
    80000d3a:	7942                	ld	s2,48(sp)
    80000d3c:	79a2                	ld	s3,40(sp)
    80000d3e:	7a02                	ld	s4,32(sp)
    80000d40:	6ae2                	ld	s5,24(sp)
    80000d42:	6b42                	ld	s6,16(sp)
    80000d44:	6ba2                	ld	s7,8(sp)
    80000d46:	6161                	add	sp,sp,80
    80000d48:	8082                	ret
    80000d4a:	fff90713          	add	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d4e:	9742                	add	a4,a4,a6
      --max;
    80000d50:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d54:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d58:	04e58663          	beq	a1,a4,80000da4 <copyinstr+0xa2>
{
    80000d5c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d5e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d62:	85a6                	mv	a1,s1
    80000d64:	8552                	mv	a0,s4
    80000d66:	fffff097          	auipc	ra,0xfffff
    80000d6a:	7e0080e7          	jalr	2016(ra) # 80000546 <walkaddr>
    if(pa0 == 0)
    80000d6e:	cd0d                	beqz	a0,80000da8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d70:	417486b3          	sub	a3,s1,s7
    80000d74:	96ce                	add	a3,a3,s3
    if(n > max)
    80000d76:	00d97363          	bgeu	s2,a3,80000d7c <copyinstr+0x7a>
    80000d7a:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000d7c:	955e                	add	a0,a0,s7
    80000d7e:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000d80:	c695                	beqz	a3,80000dac <copyinstr+0xaa>
    80000d82:	87da                	mv	a5,s6
    80000d84:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d86:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d8a:	96da                	add	a3,a3,s6
    80000d8c:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d8e:	00f60733          	add	a4,a2,a5
    80000d92:	00074703          	lbu	a4,0(a4)
    80000d96:	db49                	beqz	a4,80000d28 <copyinstr+0x26>
        *dst = *p;
    80000d98:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d9c:	0785                	add	a5,a5,1
    while(n > 0){
    80000d9e:	fed797e3          	bne	a5,a3,80000d8c <copyinstr+0x8a>
    80000da2:	b765                	j	80000d4a <copyinstr+0x48>
    80000da4:	4781                	li	a5,0
    80000da6:	b761                	j	80000d2e <copyinstr+0x2c>
      return -1;
    80000da8:	557d                	li	a0,-1
    80000daa:	b769                	j	80000d34 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000dac:	6b85                	lui	s7,0x1
    80000dae:	9ba6                	add	s7,s7,s1
    80000db0:	87da                	mv	a5,s6
    80000db2:	b76d                	j	80000d5c <copyinstr+0x5a>
  int got_null = 0;
    80000db4:	4781                	li	a5,0
  if(got_null){
    80000db6:	37fd                	addw	a5,a5,-1
    80000db8:	0007851b          	sext.w	a0,a5
}
    80000dbc:	8082                	ret

0000000080000dbe <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dbe:	7139                	add	sp,sp,-64
    80000dc0:	fc06                	sd	ra,56(sp)
    80000dc2:	f822                	sd	s0,48(sp)
    80000dc4:	f426                	sd	s1,40(sp)
    80000dc6:	f04a                	sd	s2,32(sp)
    80000dc8:	ec4e                	sd	s3,24(sp)
    80000dca:	e852                	sd	s4,16(sp)
    80000dcc:	e456                	sd	s5,8(sp)
    80000dce:	e05a                	sd	s6,0(sp)
    80000dd0:	0080                	add	s0,sp,64
    80000dd2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd4:	00008497          	auipc	s1,0x8
    80000dd8:	f8c48493          	add	s1,s1,-116 # 80008d60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ddc:	8b26                	mv	s6,s1
    80000dde:	04fa5937          	lui	s2,0x4fa5
    80000de2:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000de6:	0932                	sll	s2,s2,0xc
    80000de8:	fa590913          	add	s2,s2,-91
    80000dec:	0932                	sll	s2,s2,0xc
    80000dee:	fa590913          	add	s2,s2,-91
    80000df2:	0932                	sll	s2,s2,0xc
    80000df4:	fa590913          	add	s2,s2,-91
    80000df8:	040009b7          	lui	s3,0x4000
    80000dfc:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000dfe:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	0000ea97          	auipc	s5,0xe
    80000e04:	960a8a93          	add	s5,s5,-1696 # 8000e760 <tickslock>
    char *pa = kalloc();
    80000e08:	fffff097          	auipc	ra,0xfffff
    80000e0c:	312080e7          	jalr	786(ra) # 8000011a <kalloc>
    80000e10:	862a                	mv	a2,a0
    if(pa == 0)
    80000e12:	c121                	beqz	a0,80000e52 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000e14:	416485b3          	sub	a1,s1,s6
    80000e18:	858d                	sra	a1,a1,0x3
    80000e1a:	032585b3          	mul	a1,a1,s2
    80000e1e:	2585                	addw	a1,a1,1
    80000e20:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e24:	4719                	li	a4,6
    80000e26:	6685                	lui	a3,0x1
    80000e28:	40b985b3          	sub	a1,s3,a1
    80000e2c:	8552                	mv	a0,s4
    80000e2e:	00000097          	auipc	ra,0x0
    80000e32:	81e080e7          	jalr	-2018(ra) # 8000064c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	16848493          	add	s1,s1,360
    80000e3a:	fd5497e3          	bne	s1,s5,80000e08 <proc_mapstacks+0x4a>
  }
}
    80000e3e:	70e2                	ld	ra,56(sp)
    80000e40:	7442                	ld	s0,48(sp)
    80000e42:	74a2                	ld	s1,40(sp)
    80000e44:	7902                	ld	s2,32(sp)
    80000e46:	69e2                	ld	s3,24(sp)
    80000e48:	6a42                	ld	s4,16(sp)
    80000e4a:	6aa2                	ld	s5,8(sp)
    80000e4c:	6b02                	ld	s6,0(sp)
    80000e4e:	6121                	add	sp,sp,64
    80000e50:	8082                	ret
      panic("kalloc");
    80000e52:	00007517          	auipc	a0,0x7
    80000e56:	34650513          	add	a0,a0,838 # 80008198 <etext+0x198>
    80000e5a:	00005097          	auipc	ra,0x5
    80000e5e:	008080e7          	jalr	8(ra) # 80005e62 <panic>

0000000080000e62 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e62:	7139                	add	sp,sp,-64
    80000e64:	fc06                	sd	ra,56(sp)
    80000e66:	f822                	sd	s0,48(sp)
    80000e68:	f426                	sd	s1,40(sp)
    80000e6a:	f04a                	sd	s2,32(sp)
    80000e6c:	ec4e                	sd	s3,24(sp)
    80000e6e:	e852                	sd	s4,16(sp)
    80000e70:	e456                	sd	s5,8(sp)
    80000e72:	e05a                	sd	s6,0(sp)
    80000e74:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e76:	00007597          	auipc	a1,0x7
    80000e7a:	32a58593          	add	a1,a1,810 # 800081a0 <etext+0x1a0>
    80000e7e:	00008517          	auipc	a0,0x8
    80000e82:	ab250513          	add	a0,a0,-1358 # 80008930 <pid_lock>
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	4c6080e7          	jalr	1222(ra) # 8000634c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e8e:	00007597          	auipc	a1,0x7
    80000e92:	31a58593          	add	a1,a1,794 # 800081a8 <etext+0x1a8>
    80000e96:	00008517          	auipc	a0,0x8
    80000e9a:	ab250513          	add	a0,a0,-1358 # 80008948 <wait_lock>
    80000e9e:	00005097          	auipc	ra,0x5
    80000ea2:	4ae080e7          	jalr	1198(ra) # 8000634c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea6:	00008497          	auipc	s1,0x8
    80000eaa:	eba48493          	add	s1,s1,-326 # 80008d60 <proc>
      initlock(&p->lock, "proc");
    80000eae:	00007b17          	auipc	s6,0x7
    80000eb2:	30ab0b13          	add	s6,s6,778 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000eb6:	8aa6                	mv	s5,s1
    80000eb8:	04fa5937          	lui	s2,0x4fa5
    80000ebc:	fa590913          	add	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000ec0:	0932                	sll	s2,s2,0xc
    80000ec2:	fa590913          	add	s2,s2,-91
    80000ec6:	0932                	sll	s2,s2,0xc
    80000ec8:	fa590913          	add	s2,s2,-91
    80000ecc:	0932                	sll	s2,s2,0xc
    80000ece:	fa590913          	add	s2,s2,-91
    80000ed2:	040009b7          	lui	s3,0x4000
    80000ed6:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ed8:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eda:	0000ea17          	auipc	s4,0xe
    80000ede:	886a0a13          	add	s4,s4,-1914 # 8000e760 <tickslock>
      initlock(&p->lock, "proc");
    80000ee2:	85da                	mv	a1,s6
    80000ee4:	8526                	mv	a0,s1
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	466080e7          	jalr	1126(ra) # 8000634c <initlock>
      p->state = UNUSED;
    80000eee:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ef2:	415487b3          	sub	a5,s1,s5
    80000ef6:	878d                	sra	a5,a5,0x3
    80000ef8:	032787b3          	mul	a5,a5,s2
    80000efc:	2785                	addw	a5,a5,1
    80000efe:	00d7979b          	sllw	a5,a5,0xd
    80000f02:	40f987b3          	sub	a5,s3,a5
    80000f06:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f08:	16848493          	add	s1,s1,360
    80000f0c:	fd449be3          	bne	s1,s4,80000ee2 <procinit+0x80>
  }
}
    80000f10:	70e2                	ld	ra,56(sp)
    80000f12:	7442                	ld	s0,48(sp)
    80000f14:	74a2                	ld	s1,40(sp)
    80000f16:	7902                	ld	s2,32(sp)
    80000f18:	69e2                	ld	s3,24(sp)
    80000f1a:	6a42                	ld	s4,16(sp)
    80000f1c:	6aa2                	ld	s5,8(sp)
    80000f1e:	6b02                	ld	s6,0(sp)
    80000f20:	6121                	add	sp,sp,64
    80000f22:	8082                	ret

0000000080000f24 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f24:	1141                	add	sp,sp,-16
    80000f26:	e422                	sd	s0,8(sp)
    80000f28:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f2a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f2c:	2501                	sext.w	a0,a0
    80000f2e:	6422                	ld	s0,8(sp)
    80000f30:	0141                	add	sp,sp,16
    80000f32:	8082                	ret

0000000080000f34 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f34:	1141                	add	sp,sp,-16
    80000f36:	e422                	sd	s0,8(sp)
    80000f38:	0800                	add	s0,sp,16
    80000f3a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f3c:	2781                	sext.w	a5,a5
    80000f3e:	079e                	sll	a5,a5,0x7
  return c;
}
    80000f40:	00008517          	auipc	a0,0x8
    80000f44:	a2050513          	add	a0,a0,-1504 # 80008960 <cpus>
    80000f48:	953e                	add	a0,a0,a5
    80000f4a:	6422                	ld	s0,8(sp)
    80000f4c:	0141                	add	sp,sp,16
    80000f4e:	8082                	ret

0000000080000f50 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f50:	1101                	add	sp,sp,-32
    80000f52:	ec06                	sd	ra,24(sp)
    80000f54:	e822                	sd	s0,16(sp)
    80000f56:	e426                	sd	s1,8(sp)
    80000f58:	1000                	add	s0,sp,32
  push_off();
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	436080e7          	jalr	1078(ra) # 80006390 <push_off>
    80000f62:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f64:	2781                	sext.w	a5,a5
    80000f66:	079e                	sll	a5,a5,0x7
    80000f68:	00008717          	auipc	a4,0x8
    80000f6c:	9c870713          	add	a4,a4,-1592 # 80008930 <pid_lock>
    80000f70:	97ba                	add	a5,a5,a4
    80000f72:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	4bc080e7          	jalr	1212(ra) # 80006430 <pop_off>
  return p;
}
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	60e2                	ld	ra,24(sp)
    80000f80:	6442                	ld	s0,16(sp)
    80000f82:	64a2                	ld	s1,8(sp)
    80000f84:	6105                	add	sp,sp,32
    80000f86:	8082                	ret

0000000080000f88 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f88:	1141                	add	sp,sp,-16
    80000f8a:	e406                	sd	ra,8(sp)
    80000f8c:	e022                	sd	s0,0(sp)
    80000f8e:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	fc0080e7          	jalr	-64(ra) # 80000f50 <myproc>
    80000f98:	00005097          	auipc	ra,0x5
    80000f9c:	4f8080e7          	jalr	1272(ra) # 80006490 <release>

  if (first) {
    80000fa0:	00008797          	auipc	a5,0x8
    80000fa4:	8f07a783          	lw	a5,-1808(a5) # 80008890 <first.1>
    80000fa8:	eb89                	bnez	a5,80000fba <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000faa:	00001097          	auipc	ra,0x1
    80000fae:	ce4080e7          	jalr	-796(ra) # 80001c8e <usertrapret>
}
    80000fb2:	60a2                	ld	ra,8(sp)
    80000fb4:	6402                	ld	s0,0(sp)
    80000fb6:	0141                	add	sp,sp,16
    80000fb8:	8082                	ret
    fsinit(ROOTDEV);
    80000fba:	4505                	li	a0,1
    80000fbc:	00002097          	auipc	ra,0x2
    80000fc0:	a4e080e7          	jalr	-1458(ra) # 80002a0a <fsinit>
    first = 0;
    80000fc4:	00008797          	auipc	a5,0x8
    80000fc8:	8c07a623          	sw	zero,-1844(a5) # 80008890 <first.1>
    __sync_synchronize();
    80000fcc:	0ff0000f          	fence
    80000fd0:	bfe9                	j	80000faa <forkret+0x22>

0000000080000fd2 <allocpid>:
{
    80000fd2:	1101                	add	sp,sp,-32
    80000fd4:	ec06                	sd	ra,24(sp)
    80000fd6:	e822                	sd	s0,16(sp)
    80000fd8:	e426                	sd	s1,8(sp)
    80000fda:	e04a                	sd	s2,0(sp)
    80000fdc:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80000fde:	00008917          	auipc	s2,0x8
    80000fe2:	95290913          	add	s2,s2,-1710 # 80008930 <pid_lock>
    80000fe6:	854a                	mv	a0,s2
    80000fe8:	00005097          	auipc	ra,0x5
    80000fec:	3f4080e7          	jalr	1012(ra) # 800063dc <acquire>
  pid = nextpid;
    80000ff0:	00008797          	auipc	a5,0x8
    80000ff4:	8a478793          	add	a5,a5,-1884 # 80008894 <nextpid>
    80000ff8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ffa:	0014871b          	addw	a4,s1,1
    80000ffe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001000:	854a                	mv	a0,s2
    80001002:	00005097          	auipc	ra,0x5
    80001006:	48e080e7          	jalr	1166(ra) # 80006490 <release>
}
    8000100a:	8526                	mv	a0,s1
    8000100c:	60e2                	ld	ra,24(sp)
    8000100e:	6442                	ld	s0,16(sp)
    80001010:	64a2                	ld	s1,8(sp)
    80001012:	6902                	ld	s2,0(sp)
    80001014:	6105                	add	sp,sp,32
    80001016:	8082                	ret

0000000080001018 <proc_pagetable>:
{
    80001018:	1101                	add	sp,sp,-32
    8000101a:	ec06                	sd	ra,24(sp)
    8000101c:	e822                	sd	s0,16(sp)
    8000101e:	e426                	sd	s1,8(sp)
    80001020:	e04a                	sd	s2,0(sp)
    80001022:	1000                	add	s0,sp,32
    80001024:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	820080e7          	jalr	-2016(ra) # 80000846 <uvmcreate>
    8000102e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001030:	c121                	beqz	a0,80001070 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001032:	4729                	li	a4,10
    80001034:	00006697          	auipc	a3,0x6
    80001038:	fcc68693          	add	a3,a3,-52 # 80007000 <_trampoline>
    8000103c:	6605                	lui	a2,0x1
    8000103e:	040005b7          	lui	a1,0x4000
    80001042:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001044:	05b2                	sll	a1,a1,0xc
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	542080e7          	jalr	1346(ra) # 80000588 <mappages>
    8000104e:	02054863          	bltz	a0,8000107e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001052:	4719                	li	a4,6
    80001054:	05893683          	ld	a3,88(s2)
    80001058:	6605                	lui	a2,0x1
    8000105a:	020005b7          	lui	a1,0x2000
    8000105e:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001060:	05b6                	sll	a1,a1,0xd
    80001062:	8526                	mv	a0,s1
    80001064:	fffff097          	auipc	ra,0xfffff
    80001068:	524080e7          	jalr	1316(ra) # 80000588 <mappages>
    8000106c:	02054163          	bltz	a0,8000108e <proc_pagetable+0x76>
}
    80001070:	8526                	mv	a0,s1
    80001072:	60e2                	ld	ra,24(sp)
    80001074:	6442                	ld	s0,16(sp)
    80001076:	64a2                	ld	s1,8(sp)
    80001078:	6902                	ld	s2,0(sp)
    8000107a:	6105                	add	sp,sp,32
    8000107c:	8082                	ret
    uvmfree(pagetable, 0);
    8000107e:	4581                	li	a1,0
    80001080:	8526                	mv	a0,s1
    80001082:	00000097          	auipc	ra,0x0
    80001086:	9d6080e7          	jalr	-1578(ra) # 80000a58 <uvmfree>
    return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	b7d5                	j	80001070 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000108e:	4681                	li	a3,0
    80001090:	4605                	li	a2,1
    80001092:	040005b7          	lui	a1,0x4000
    80001096:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001098:	05b2                	sll	a1,a1,0xc
    8000109a:	8526                	mv	a0,s1
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	6d6080e7          	jalr	1750(ra) # 80000772 <uvmunmap>
    uvmfree(pagetable, 0);
    800010a4:	4581                	li	a1,0
    800010a6:	8526                	mv	a0,s1
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	9b0080e7          	jalr	-1616(ra) # 80000a58 <uvmfree>
    return 0;
    800010b0:	4481                	li	s1,0
    800010b2:	bf7d                	j	80001070 <proc_pagetable+0x58>

00000000800010b4 <proc_freepagetable>:
{
    800010b4:	1101                	add	sp,sp,-32
    800010b6:	ec06                	sd	ra,24(sp)
    800010b8:	e822                	sd	s0,16(sp)
    800010ba:	e426                	sd	s1,8(sp)
    800010bc:	e04a                	sd	s2,0(sp)
    800010be:	1000                	add	s0,sp,32
    800010c0:	84aa                	mv	s1,a0
    800010c2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c4:	4681                	li	a3,0
    800010c6:	4605                	li	a2,1
    800010c8:	040005b7          	lui	a1,0x4000
    800010cc:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010ce:	05b2                	sll	a1,a1,0xc
    800010d0:	fffff097          	auipc	ra,0xfffff
    800010d4:	6a2080e7          	jalr	1698(ra) # 80000772 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010d8:	4681                	li	a3,0
    800010da:	4605                	li	a2,1
    800010dc:	020005b7          	lui	a1,0x2000
    800010e0:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010e2:	05b6                	sll	a1,a1,0xd
    800010e4:	8526                	mv	a0,s1
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	68c080e7          	jalr	1676(ra) # 80000772 <uvmunmap>
  uvmfree(pagetable, sz);
    800010ee:	85ca                	mv	a1,s2
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	966080e7          	jalr	-1690(ra) # 80000a58 <uvmfree>
}
    800010fa:	60e2                	ld	ra,24(sp)
    800010fc:	6442                	ld	s0,16(sp)
    800010fe:	64a2                	ld	s1,8(sp)
    80001100:	6902                	ld	s2,0(sp)
    80001102:	6105                	add	sp,sp,32
    80001104:	8082                	ret

0000000080001106 <freeproc>:
{
    80001106:	1101                	add	sp,sp,-32
    80001108:	ec06                	sd	ra,24(sp)
    8000110a:	e822                	sd	s0,16(sp)
    8000110c:	e426                	sd	s1,8(sp)
    8000110e:	1000                	add	s0,sp,32
    80001110:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001112:	6d28                	ld	a0,88(a0)
    80001114:	c509                	beqz	a0,8000111e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	f06080e7          	jalr	-250(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000111e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001122:	68a8                	ld	a0,80(s1)
    80001124:	c511                	beqz	a0,80001130 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001126:	64ac                	ld	a1,72(s1)
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	f8c080e7          	jalr	-116(ra) # 800010b4 <proc_freepagetable>
  p->pagetable = 0;
    80001130:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001134:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001138:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000113c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001140:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001144:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001148:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000114c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001150:	0004ac23          	sw	zero,24(s1)
}
    80001154:	60e2                	ld	ra,24(sp)
    80001156:	6442                	ld	s0,16(sp)
    80001158:	64a2                	ld	s1,8(sp)
    8000115a:	6105                	add	sp,sp,32
    8000115c:	8082                	ret

000000008000115e <allocproc>:
{
    8000115e:	1101                	add	sp,sp,-32
    80001160:	ec06                	sd	ra,24(sp)
    80001162:	e822                	sd	s0,16(sp)
    80001164:	e426                	sd	s1,8(sp)
    80001166:	e04a                	sd	s2,0(sp)
    80001168:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000116a:	00008497          	auipc	s1,0x8
    8000116e:	bf648493          	add	s1,s1,-1034 # 80008d60 <proc>
    80001172:	0000d917          	auipc	s2,0xd
    80001176:	5ee90913          	add	s2,s2,1518 # 8000e760 <tickslock>
    acquire(&p->lock);
    8000117a:	8526                	mv	a0,s1
    8000117c:	00005097          	auipc	ra,0x5
    80001180:	260080e7          	jalr	608(ra) # 800063dc <acquire>
    if(p->state == UNUSED) {
    80001184:	4c9c                	lw	a5,24(s1)
    80001186:	cf81                	beqz	a5,8000119e <allocproc+0x40>
      release(&p->lock);
    80001188:	8526                	mv	a0,s1
    8000118a:	00005097          	auipc	ra,0x5
    8000118e:	306080e7          	jalr	774(ra) # 80006490 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001192:	16848493          	add	s1,s1,360
    80001196:	ff2492e3          	bne	s1,s2,8000117a <allocproc+0x1c>
  return 0;
    8000119a:	4481                	li	s1,0
    8000119c:	a889                	j	800011ee <allocproc+0x90>
  p->pid = allocpid();
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	e34080e7          	jalr	-460(ra) # 80000fd2 <allocpid>
    800011a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011a8:	4785                	li	a5,1
    800011aa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011ac:	fffff097          	auipc	ra,0xfffff
    800011b0:	f6e080e7          	jalr	-146(ra) # 8000011a <kalloc>
    800011b4:	892a                	mv	s2,a0
    800011b6:	eca8                	sd	a0,88(s1)
    800011b8:	c131                	beqz	a0,800011fc <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	e5c080e7          	jalr	-420(ra) # 80001018 <proc_pagetable>
    800011c4:	892a                	mv	s2,a0
    800011c6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800011c8:	c531                	beqz	a0,80001214 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011ca:	07000613          	li	a2,112
    800011ce:	4581                	li	a1,0
    800011d0:	06048513          	add	a0,s1,96
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	ff0080e7          	jalr	-16(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    800011dc:	00000797          	auipc	a5,0x0
    800011e0:	dac78793          	add	a5,a5,-596 # 80000f88 <forkret>
    800011e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011e6:	60bc                	ld	a5,64(s1)
    800011e8:	6705                	lui	a4,0x1
    800011ea:	97ba                	add	a5,a5,a4
    800011ec:	f4bc                	sd	a5,104(s1)
}
    800011ee:	8526                	mv	a0,s1
    800011f0:	60e2                	ld	ra,24(sp)
    800011f2:	6442                	ld	s0,16(sp)
    800011f4:	64a2                	ld	s1,8(sp)
    800011f6:	6902                	ld	s2,0(sp)
    800011f8:	6105                	add	sp,sp,32
    800011fa:	8082                	ret
    freeproc(p);
    800011fc:	8526                	mv	a0,s1
    800011fe:	00000097          	auipc	ra,0x0
    80001202:	f08080e7          	jalr	-248(ra) # 80001106 <freeproc>
    release(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	288080e7          	jalr	648(ra) # 80006490 <release>
    return 0;
    80001210:	84ca                	mv	s1,s2
    80001212:	bff1                	j	800011ee <allocproc+0x90>
    freeproc(p);
    80001214:	8526                	mv	a0,s1
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	ef0080e7          	jalr	-272(ra) # 80001106 <freeproc>
    release(&p->lock);
    8000121e:	8526                	mv	a0,s1
    80001220:	00005097          	auipc	ra,0x5
    80001224:	270080e7          	jalr	624(ra) # 80006490 <release>
    return 0;
    80001228:	84ca                	mv	s1,s2
    8000122a:	b7d1                	j	800011ee <allocproc+0x90>

000000008000122c <userinit>:
{
    8000122c:	1101                	add	sp,sp,-32
    8000122e:	ec06                	sd	ra,24(sp)
    80001230:	e822                	sd	s0,16(sp)
    80001232:	e426                	sd	s1,8(sp)
    80001234:	1000                	add	s0,sp,32
  p = allocproc();
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f28080e7          	jalr	-216(ra) # 8000115e <allocproc>
    8000123e:	84aa                	mv	s1,a0
  initproc = p;
    80001240:	00007797          	auipc	a5,0x7
    80001244:	6aa7b823          	sd	a0,1712(a5) # 800088f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001248:	03400613          	li	a2,52
    8000124c:	00007597          	auipc	a1,0x7
    80001250:	65458593          	add	a1,a1,1620 # 800088a0 <initcode>
    80001254:	6928                	ld	a0,80(a0)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	61e080e7          	jalr	1566(ra) # 80000874 <uvmfirst>
  p->sz = PGSIZE;
    8000125e:	6785                	lui	a5,0x1
    80001260:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001262:	6cb8                	ld	a4,88(s1)
    80001264:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001268:	6cb8                	ld	a4,88(s1)
    8000126a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000126c:	4641                	li	a2,16
    8000126e:	00007597          	auipc	a1,0x7
    80001272:	f5258593          	add	a1,a1,-174 # 800081c0 <etext+0x1c0>
    80001276:	15848513          	add	a0,s1,344
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	08c080e7          	jalr	140(ra) # 80000306 <safestrcpy>
  p->cwd = namei("/");
    80001282:	00007517          	auipc	a0,0x7
    80001286:	f4e50513          	add	a0,a0,-178 # 800081d0 <etext+0x1d0>
    8000128a:	00002097          	auipc	ra,0x2
    8000128e:	1d2080e7          	jalr	466(ra) # 8000345c <namei>
    80001292:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001296:	478d                	li	a5,3
    80001298:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000129a:	8526                	mv	a0,s1
    8000129c:	00005097          	auipc	ra,0x5
    800012a0:	1f4080e7          	jalr	500(ra) # 80006490 <release>
}
    800012a4:	60e2                	ld	ra,24(sp)
    800012a6:	6442                	ld	s0,16(sp)
    800012a8:	64a2                	ld	s1,8(sp)
    800012aa:	6105                	add	sp,sp,32
    800012ac:	8082                	ret

00000000800012ae <growproc>:
{
    800012ae:	1101                	add	sp,sp,-32
    800012b0:	ec06                	sd	ra,24(sp)
    800012b2:	e822                	sd	s0,16(sp)
    800012b4:	e426                	sd	s1,8(sp)
    800012b6:	e04a                	sd	s2,0(sp)
    800012b8:	1000                	add	s0,sp,32
    800012ba:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	c94080e7          	jalr	-876(ra) # 80000f50 <myproc>
    800012c4:	84aa                	mv	s1,a0
  sz = p->sz;
    800012c6:	652c                	ld	a1,72(a0)
  if(n > 0){
    800012c8:	01204c63          	bgtz	s2,800012e0 <growproc+0x32>
  } else if(n < 0){
    800012cc:	02094663          	bltz	s2,800012f8 <growproc+0x4a>
  p->sz = sz;
    800012d0:	e4ac                	sd	a1,72(s1)
  return 0;
    800012d2:	4501                	li	a0,0
}
    800012d4:	60e2                	ld	ra,24(sp)
    800012d6:	6442                	ld	s0,16(sp)
    800012d8:	64a2                	ld	s1,8(sp)
    800012da:	6902                	ld	s2,0(sp)
    800012dc:	6105                	add	sp,sp,32
    800012de:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800012e0:	4691                	li	a3,4
    800012e2:	00b90633          	add	a2,s2,a1
    800012e6:	6928                	ld	a0,80(a0)
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	646080e7          	jalr	1606(ra) # 8000092e <uvmalloc>
    800012f0:	85aa                	mv	a1,a0
    800012f2:	fd79                	bnez	a0,800012d0 <growproc+0x22>
      return -1;
    800012f4:	557d                	li	a0,-1
    800012f6:	bff9                	j	800012d4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012f8:	00b90633          	add	a2,s2,a1
    800012fc:	6928                	ld	a0,80(a0)
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	5e8080e7          	jalr	1512(ra) # 800008e6 <uvmdealloc>
    80001306:	85aa                	mv	a1,a0
    80001308:	b7e1                	j	800012d0 <growproc+0x22>

000000008000130a <fork>:
{
    8000130a:	7139                	add	sp,sp,-64
    8000130c:	fc06                	sd	ra,56(sp)
    8000130e:	f822                	sd	s0,48(sp)
    80001310:	f04a                	sd	s2,32(sp)
    80001312:	e456                	sd	s5,8(sp)
    80001314:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	c3a080e7          	jalr	-966(ra) # 80000f50 <myproc>
    8000131e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001320:	00000097          	auipc	ra,0x0
    80001324:	e3e080e7          	jalr	-450(ra) # 8000115e <allocproc>
    80001328:	12050063          	beqz	a0,80001448 <fork+0x13e>
    8000132c:	e852                	sd	s4,16(sp)
    8000132e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001330:	048ab603          	ld	a2,72(s5)
    80001334:	692c                	ld	a1,80(a0)
    80001336:	050ab503          	ld	a0,80(s5)
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	758080e7          	jalr	1880(ra) # 80000a92 <uvmcopy>
    80001342:	04054a63          	bltz	a0,80001396 <fork+0x8c>
    80001346:	f426                	sd	s1,40(sp)
    80001348:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000134a:	048ab783          	ld	a5,72(s5)
    8000134e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001352:	058ab683          	ld	a3,88(s5)
    80001356:	87b6                	mv	a5,a3
    80001358:	058a3703          	ld	a4,88(s4)
    8000135c:	12068693          	add	a3,a3,288
    80001360:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001364:	6788                	ld	a0,8(a5)
    80001366:	6b8c                	ld	a1,16(a5)
    80001368:	6f90                	ld	a2,24(a5)
    8000136a:	01073023          	sd	a6,0(a4)
    8000136e:	e708                	sd	a0,8(a4)
    80001370:	eb0c                	sd	a1,16(a4)
    80001372:	ef10                	sd	a2,24(a4)
    80001374:	02078793          	add	a5,a5,32
    80001378:	02070713          	add	a4,a4,32
    8000137c:	fed792e3          	bne	a5,a3,80001360 <fork+0x56>
  np->trapframe->a0 = 0;
    80001380:	058a3783          	ld	a5,88(s4)
    80001384:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001388:	0d0a8493          	add	s1,s5,208
    8000138c:	0d0a0913          	add	s2,s4,208
    80001390:	150a8993          	add	s3,s5,336
    80001394:	a015                	j	800013b8 <fork+0xae>
    freeproc(np);
    80001396:	8552                	mv	a0,s4
    80001398:	00000097          	auipc	ra,0x0
    8000139c:	d6e080e7          	jalr	-658(ra) # 80001106 <freeproc>
    release(&np->lock);
    800013a0:	8552                	mv	a0,s4
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	0ee080e7          	jalr	238(ra) # 80006490 <release>
    return -1;
    800013aa:	597d                	li	s2,-1
    800013ac:	6a42                	ld	s4,16(sp)
    800013ae:	a071                	j	8000143a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800013b0:	04a1                	add	s1,s1,8
    800013b2:	0921                	add	s2,s2,8
    800013b4:	01348b63          	beq	s1,s3,800013ca <fork+0xc0>
    if(p->ofile[i])
    800013b8:	6088                	ld	a0,0(s1)
    800013ba:	d97d                	beqz	a0,800013b0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800013bc:	00002097          	auipc	ra,0x2
    800013c0:	718080e7          	jalr	1816(ra) # 80003ad4 <filedup>
    800013c4:	00a93023          	sd	a0,0(s2)
    800013c8:	b7e5                	j	800013b0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800013ca:	150ab503          	ld	a0,336(s5)
    800013ce:	00002097          	auipc	ra,0x2
    800013d2:	882080e7          	jalr	-1918(ra) # 80002c50 <idup>
    800013d6:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013da:	4641                	li	a2,16
    800013dc:	158a8593          	add	a1,s5,344
    800013e0:	158a0513          	add	a0,s4,344
    800013e4:	fffff097          	auipc	ra,0xfffff
    800013e8:	f22080e7          	jalr	-222(ra) # 80000306 <safestrcpy>
  pid = np->pid;
    800013ec:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013f0:	8552                	mv	a0,s4
    800013f2:	00005097          	auipc	ra,0x5
    800013f6:	09e080e7          	jalr	158(ra) # 80006490 <release>
  acquire(&wait_lock);
    800013fa:	00007497          	auipc	s1,0x7
    800013fe:	54e48493          	add	s1,s1,1358 # 80008948 <wait_lock>
    80001402:	8526                	mv	a0,s1
    80001404:	00005097          	auipc	ra,0x5
    80001408:	fd8080e7          	jalr	-40(ra) # 800063dc <acquire>
  np->parent = p;
    8000140c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001410:	8526                	mv	a0,s1
    80001412:	00005097          	auipc	ra,0x5
    80001416:	07e080e7          	jalr	126(ra) # 80006490 <release>
  acquire(&np->lock);
    8000141a:	8552                	mv	a0,s4
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	fc0080e7          	jalr	-64(ra) # 800063dc <acquire>
  np->state = RUNNABLE;
    80001424:	478d                	li	a5,3
    80001426:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000142a:	8552                	mv	a0,s4
    8000142c:	00005097          	auipc	ra,0x5
    80001430:	064080e7          	jalr	100(ra) # 80006490 <release>
  return pid;
    80001434:	74a2                	ld	s1,40(sp)
    80001436:	69e2                	ld	s3,24(sp)
    80001438:	6a42                	ld	s4,16(sp)
}
    8000143a:	854a                	mv	a0,s2
    8000143c:	70e2                	ld	ra,56(sp)
    8000143e:	7442                	ld	s0,48(sp)
    80001440:	7902                	ld	s2,32(sp)
    80001442:	6aa2                	ld	s5,8(sp)
    80001444:	6121                	add	sp,sp,64
    80001446:	8082                	ret
    return -1;
    80001448:	597d                	li	s2,-1
    8000144a:	bfc5                	j	8000143a <fork+0x130>

000000008000144c <scheduler>:
{
    8000144c:	7139                	add	sp,sp,-64
    8000144e:	fc06                	sd	ra,56(sp)
    80001450:	f822                	sd	s0,48(sp)
    80001452:	f426                	sd	s1,40(sp)
    80001454:	f04a                	sd	s2,32(sp)
    80001456:	ec4e                	sd	s3,24(sp)
    80001458:	e852                	sd	s4,16(sp)
    8000145a:	e456                	sd	s5,8(sp)
    8000145c:	e05a                	sd	s6,0(sp)
    8000145e:	0080                	add	s0,sp,64
    80001460:	8792                	mv	a5,tp
  int id = r_tp();
    80001462:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001464:	00779a93          	sll	s5,a5,0x7
    80001468:	00007717          	auipc	a4,0x7
    8000146c:	4c870713          	add	a4,a4,1224 # 80008930 <pid_lock>
    80001470:	9756                	add	a4,a4,s5
    80001472:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001476:	00007717          	auipc	a4,0x7
    8000147a:	4f270713          	add	a4,a4,1266 # 80008968 <cpus+0x8>
    8000147e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001480:	498d                	li	s3,3
        p->state = RUNNING;
    80001482:	4b11                	li	s6,4
        c->proc = p;
    80001484:	079e                	sll	a5,a5,0x7
    80001486:	00007a17          	auipc	s4,0x7
    8000148a:	4aaa0a13          	add	s4,s4,1194 # 80008930 <pid_lock>
    8000148e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001490:	0000d917          	auipc	s2,0xd
    80001494:	2d090913          	add	s2,s2,720 # 8000e760 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001498:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000149c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014a0:	10079073          	csrw	sstatus,a5
    800014a4:	00008497          	auipc	s1,0x8
    800014a8:	8bc48493          	add	s1,s1,-1860 # 80008d60 <proc>
    800014ac:	a811                	j	800014c0 <scheduler+0x74>
      release(&p->lock);
    800014ae:	8526                	mv	a0,s1
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	fe0080e7          	jalr	-32(ra) # 80006490 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014b8:	16848493          	add	s1,s1,360
    800014bc:	fd248ee3          	beq	s1,s2,80001498 <scheduler+0x4c>
      acquire(&p->lock);
    800014c0:	8526                	mv	a0,s1
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	f1a080e7          	jalr	-230(ra) # 800063dc <acquire>
      if(p->state == RUNNABLE) {
    800014ca:	4c9c                	lw	a5,24(s1)
    800014cc:	ff3791e3          	bne	a5,s3,800014ae <scheduler+0x62>
        p->state = RUNNING;
    800014d0:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800014d4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014d8:	06048593          	add	a1,s1,96
    800014dc:	8556                	mv	a0,s5
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	706080e7          	jalr	1798(ra) # 80001be4 <swtch>
        c->proc = 0;
    800014e6:	020a3823          	sd	zero,48(s4)
    800014ea:	b7d1                	j	800014ae <scheduler+0x62>

00000000800014ec <sched>:
{
    800014ec:	7179                	add	sp,sp,-48
    800014ee:	f406                	sd	ra,40(sp)
    800014f0:	f022                	sd	s0,32(sp)
    800014f2:	ec26                	sd	s1,24(sp)
    800014f4:	e84a                	sd	s2,16(sp)
    800014f6:	e44e                	sd	s3,8(sp)
    800014f8:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	a56080e7          	jalr	-1450(ra) # 80000f50 <myproc>
    80001502:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001504:	00005097          	auipc	ra,0x5
    80001508:	e5e080e7          	jalr	-418(ra) # 80006362 <holding>
    8000150c:	c93d                	beqz	a0,80001582 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000150e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001510:	2781                	sext.w	a5,a5
    80001512:	079e                	sll	a5,a5,0x7
    80001514:	00007717          	auipc	a4,0x7
    80001518:	41c70713          	add	a4,a4,1052 # 80008930 <pid_lock>
    8000151c:	97ba                	add	a5,a5,a4
    8000151e:	0a87a703          	lw	a4,168(a5)
    80001522:	4785                	li	a5,1
    80001524:	06f71763          	bne	a4,a5,80001592 <sched+0xa6>
  if(p->state == RUNNING)
    80001528:	4c98                	lw	a4,24(s1)
    8000152a:	4791                	li	a5,4
    8000152c:	06f70b63          	beq	a4,a5,800015a2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001530:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001534:	8b89                	and	a5,a5,2
  if(intr_get())
    80001536:	efb5                	bnez	a5,800015b2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001538:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000153a:	00007917          	auipc	s2,0x7
    8000153e:	3f690913          	add	s2,s2,1014 # 80008930 <pid_lock>
    80001542:	2781                	sext.w	a5,a5
    80001544:	079e                	sll	a5,a5,0x7
    80001546:	97ca                	add	a5,a5,s2
    80001548:	0ac7a983          	lw	s3,172(a5)
    8000154c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000154e:	2781                	sext.w	a5,a5
    80001550:	079e                	sll	a5,a5,0x7
    80001552:	00007597          	auipc	a1,0x7
    80001556:	41658593          	add	a1,a1,1046 # 80008968 <cpus+0x8>
    8000155a:	95be                	add	a1,a1,a5
    8000155c:	06048513          	add	a0,s1,96
    80001560:	00000097          	auipc	ra,0x0
    80001564:	684080e7          	jalr	1668(ra) # 80001be4 <swtch>
    80001568:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000156a:	2781                	sext.w	a5,a5
    8000156c:	079e                	sll	a5,a5,0x7
    8000156e:	993e                	add	s2,s2,a5
    80001570:	0b392623          	sw	s3,172(s2)
}
    80001574:	70a2                	ld	ra,40(sp)
    80001576:	7402                	ld	s0,32(sp)
    80001578:	64e2                	ld	s1,24(sp)
    8000157a:	6942                	ld	s2,16(sp)
    8000157c:	69a2                	ld	s3,8(sp)
    8000157e:	6145                	add	sp,sp,48
    80001580:	8082                	ret
    panic("sched p->lock");
    80001582:	00007517          	auipc	a0,0x7
    80001586:	c5650513          	add	a0,a0,-938 # 800081d8 <etext+0x1d8>
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	8d8080e7          	jalr	-1832(ra) # 80005e62 <panic>
    panic("sched locks");
    80001592:	00007517          	auipc	a0,0x7
    80001596:	c5650513          	add	a0,a0,-938 # 800081e8 <etext+0x1e8>
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	8c8080e7          	jalr	-1848(ra) # 80005e62 <panic>
    panic("sched running");
    800015a2:	00007517          	auipc	a0,0x7
    800015a6:	c5650513          	add	a0,a0,-938 # 800081f8 <etext+0x1f8>
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	8b8080e7          	jalr	-1864(ra) # 80005e62 <panic>
    panic("sched interruptible");
    800015b2:	00007517          	auipc	a0,0x7
    800015b6:	c5650513          	add	a0,a0,-938 # 80008208 <etext+0x208>
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	8a8080e7          	jalr	-1880(ra) # 80005e62 <panic>

00000000800015c2 <yield>:
{
    800015c2:	1101                	add	sp,sp,-32
    800015c4:	ec06                	sd	ra,24(sp)
    800015c6:	e822                	sd	s0,16(sp)
    800015c8:	e426                	sd	s1,8(sp)
    800015ca:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	984080e7          	jalr	-1660(ra) # 80000f50 <myproc>
    800015d4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	e06080e7          	jalr	-506(ra) # 800063dc <acquire>
  p->state = RUNNABLE;
    800015de:	478d                	li	a5,3
    800015e0:	cc9c                	sw	a5,24(s1)
  sched();
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	f0a080e7          	jalr	-246(ra) # 800014ec <sched>
  release(&p->lock);
    800015ea:	8526                	mv	a0,s1
    800015ec:	00005097          	auipc	ra,0x5
    800015f0:	ea4080e7          	jalr	-348(ra) # 80006490 <release>
}
    800015f4:	60e2                	ld	ra,24(sp)
    800015f6:	6442                	ld	s0,16(sp)
    800015f8:	64a2                	ld	s1,8(sp)
    800015fa:	6105                	add	sp,sp,32
    800015fc:	8082                	ret

00000000800015fe <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015fe:	7179                	add	sp,sp,-48
    80001600:	f406                	sd	ra,40(sp)
    80001602:	f022                	sd	s0,32(sp)
    80001604:	ec26                	sd	s1,24(sp)
    80001606:	e84a                	sd	s2,16(sp)
    80001608:	e44e                	sd	s3,8(sp)
    8000160a:	1800                	add	s0,sp,48
    8000160c:	89aa                	mv	s3,a0
    8000160e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001610:	00000097          	auipc	ra,0x0
    80001614:	940080e7          	jalr	-1728(ra) # 80000f50 <myproc>
    80001618:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	dc2080e7          	jalr	-574(ra) # 800063dc <acquire>
  release(lk);
    80001622:	854a                	mv	a0,s2
    80001624:	00005097          	auipc	ra,0x5
    80001628:	e6c080e7          	jalr	-404(ra) # 80006490 <release>

  // Go to sleep.
  p->chan = chan;
    8000162c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001630:	4789                	li	a5,2
    80001632:	cc9c                	sw	a5,24(s1)

  sched();
    80001634:	00000097          	auipc	ra,0x0
    80001638:	eb8080e7          	jalr	-328(ra) # 800014ec <sched>

  // Tidy up.
  p->chan = 0;
    8000163c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	e4e080e7          	jalr	-434(ra) # 80006490 <release>
  acquire(lk);
    8000164a:	854a                	mv	a0,s2
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	d90080e7          	jalr	-624(ra) # 800063dc <acquire>
}
    80001654:	70a2                	ld	ra,40(sp)
    80001656:	7402                	ld	s0,32(sp)
    80001658:	64e2                	ld	s1,24(sp)
    8000165a:	6942                	ld	s2,16(sp)
    8000165c:	69a2                	ld	s3,8(sp)
    8000165e:	6145                	add	sp,sp,48
    80001660:	8082                	ret

0000000080001662 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001662:	7139                	add	sp,sp,-64
    80001664:	fc06                	sd	ra,56(sp)
    80001666:	f822                	sd	s0,48(sp)
    80001668:	f426                	sd	s1,40(sp)
    8000166a:	f04a                	sd	s2,32(sp)
    8000166c:	ec4e                	sd	s3,24(sp)
    8000166e:	e852                	sd	s4,16(sp)
    80001670:	e456                	sd	s5,8(sp)
    80001672:	0080                	add	s0,sp,64
    80001674:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001676:	00007497          	auipc	s1,0x7
    8000167a:	6ea48493          	add	s1,s1,1770 # 80008d60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000167e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001680:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001682:	0000d917          	auipc	s2,0xd
    80001686:	0de90913          	add	s2,s2,222 # 8000e760 <tickslock>
    8000168a:	a811                	j	8000169e <wakeup+0x3c>
      }
      release(&p->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	e02080e7          	jalr	-510(ra) # 80006490 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001696:	16848493          	add	s1,s1,360
    8000169a:	03248663          	beq	s1,s2,800016c6 <wakeup+0x64>
    if(p != myproc()){
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	8b2080e7          	jalr	-1870(ra) # 80000f50 <myproc>
    800016a6:	fea488e3          	beq	s1,a0,80001696 <wakeup+0x34>
      acquire(&p->lock);
    800016aa:	8526                	mv	a0,s1
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	d30080e7          	jalr	-720(ra) # 800063dc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016b4:	4c9c                	lw	a5,24(s1)
    800016b6:	fd379be3          	bne	a5,s3,8000168c <wakeup+0x2a>
    800016ba:	709c                	ld	a5,32(s1)
    800016bc:	fd4798e3          	bne	a5,s4,8000168c <wakeup+0x2a>
        p->state = RUNNABLE;
    800016c0:	0154ac23          	sw	s5,24(s1)
    800016c4:	b7e1                	j	8000168c <wakeup+0x2a>
    }
  }
}
    800016c6:	70e2                	ld	ra,56(sp)
    800016c8:	7442                	ld	s0,48(sp)
    800016ca:	74a2                	ld	s1,40(sp)
    800016cc:	7902                	ld	s2,32(sp)
    800016ce:	69e2                	ld	s3,24(sp)
    800016d0:	6a42                	ld	s4,16(sp)
    800016d2:	6aa2                	ld	s5,8(sp)
    800016d4:	6121                	add	sp,sp,64
    800016d6:	8082                	ret

00000000800016d8 <reparent>:
{
    800016d8:	7179                	add	sp,sp,-48
    800016da:	f406                	sd	ra,40(sp)
    800016dc:	f022                	sd	s0,32(sp)
    800016de:	ec26                	sd	s1,24(sp)
    800016e0:	e84a                	sd	s2,16(sp)
    800016e2:	e44e                	sd	s3,8(sp)
    800016e4:	e052                	sd	s4,0(sp)
    800016e6:	1800                	add	s0,sp,48
    800016e8:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016ea:	00007497          	auipc	s1,0x7
    800016ee:	67648493          	add	s1,s1,1654 # 80008d60 <proc>
      pp->parent = initproc;
    800016f2:	00007a17          	auipc	s4,0x7
    800016f6:	1fea0a13          	add	s4,s4,510 # 800088f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016fa:	0000d997          	auipc	s3,0xd
    800016fe:	06698993          	add	s3,s3,102 # 8000e760 <tickslock>
    80001702:	a029                	j	8000170c <reparent+0x34>
    80001704:	16848493          	add	s1,s1,360
    80001708:	01348d63          	beq	s1,s3,80001722 <reparent+0x4a>
    if(pp->parent == p){
    8000170c:	7c9c                	ld	a5,56(s1)
    8000170e:	ff279be3          	bne	a5,s2,80001704 <reparent+0x2c>
      pp->parent = initproc;
    80001712:	000a3503          	ld	a0,0(s4)
    80001716:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001718:	00000097          	auipc	ra,0x0
    8000171c:	f4a080e7          	jalr	-182(ra) # 80001662 <wakeup>
    80001720:	b7d5                	j	80001704 <reparent+0x2c>
}
    80001722:	70a2                	ld	ra,40(sp)
    80001724:	7402                	ld	s0,32(sp)
    80001726:	64e2                	ld	s1,24(sp)
    80001728:	6942                	ld	s2,16(sp)
    8000172a:	69a2                	ld	s3,8(sp)
    8000172c:	6a02                	ld	s4,0(sp)
    8000172e:	6145                	add	sp,sp,48
    80001730:	8082                	ret

0000000080001732 <exit>:
{
    80001732:	7179                	add	sp,sp,-48
    80001734:	f406                	sd	ra,40(sp)
    80001736:	f022                	sd	s0,32(sp)
    80001738:	ec26                	sd	s1,24(sp)
    8000173a:	e84a                	sd	s2,16(sp)
    8000173c:	e44e                	sd	s3,8(sp)
    8000173e:	e052                	sd	s4,0(sp)
    80001740:	1800                	add	s0,sp,48
    80001742:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001744:	00000097          	auipc	ra,0x0
    80001748:	80c080e7          	jalr	-2036(ra) # 80000f50 <myproc>
    8000174c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000174e:	00007797          	auipc	a5,0x7
    80001752:	1a27b783          	ld	a5,418(a5) # 800088f0 <initproc>
    80001756:	0d050493          	add	s1,a0,208
    8000175a:	15050913          	add	s2,a0,336
    8000175e:	02a79363          	bne	a5,a0,80001784 <exit+0x52>
    panic("init exiting");
    80001762:	00007517          	auipc	a0,0x7
    80001766:	abe50513          	add	a0,a0,-1346 # 80008220 <etext+0x220>
    8000176a:	00004097          	auipc	ra,0x4
    8000176e:	6f8080e7          	jalr	1784(ra) # 80005e62 <panic>
      fileclose(f);
    80001772:	00002097          	auipc	ra,0x2
    80001776:	3b4080e7          	jalr	948(ra) # 80003b26 <fileclose>
      p->ofile[fd] = 0;
    8000177a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000177e:	04a1                	add	s1,s1,8
    80001780:	01248563          	beq	s1,s2,8000178a <exit+0x58>
    if(p->ofile[fd]){
    80001784:	6088                	ld	a0,0(s1)
    80001786:	f575                	bnez	a0,80001772 <exit+0x40>
    80001788:	bfdd                	j	8000177e <exit+0x4c>
  begin_op();
    8000178a:	00002097          	auipc	ra,0x2
    8000178e:	ed2080e7          	jalr	-302(ra) # 8000365c <begin_op>
  iput(p->cwd);
    80001792:	1509b503          	ld	a0,336(s3)
    80001796:	00001097          	auipc	ra,0x1
    8000179a:	6b6080e7          	jalr	1718(ra) # 80002e4c <iput>
  end_op();
    8000179e:	00002097          	auipc	ra,0x2
    800017a2:	f38080e7          	jalr	-200(ra) # 800036d6 <end_op>
  p->cwd = 0;
    800017a6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017aa:	00007497          	auipc	s1,0x7
    800017ae:	19e48493          	add	s1,s1,414 # 80008948 <wait_lock>
    800017b2:	8526                	mv	a0,s1
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	c28080e7          	jalr	-984(ra) # 800063dc <acquire>
  reparent(p);
    800017bc:	854e                	mv	a0,s3
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	f1a080e7          	jalr	-230(ra) # 800016d8 <reparent>
  wakeup(p->parent);
    800017c6:	0389b503          	ld	a0,56(s3)
    800017ca:	00000097          	auipc	ra,0x0
    800017ce:	e98080e7          	jalr	-360(ra) # 80001662 <wakeup>
  acquire(&p->lock);
    800017d2:	854e                	mv	a0,s3
    800017d4:	00005097          	auipc	ra,0x5
    800017d8:	c08080e7          	jalr	-1016(ra) # 800063dc <acquire>
  p->xstate = status;
    800017dc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800017e0:	4795                	li	a5,5
    800017e2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800017e6:	8526                	mv	a0,s1
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	ca8080e7          	jalr	-856(ra) # 80006490 <release>
  sched();
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	cfc080e7          	jalr	-772(ra) # 800014ec <sched>
  panic("zombie exit");
    800017f8:	00007517          	auipc	a0,0x7
    800017fc:	a3850513          	add	a0,a0,-1480 # 80008230 <etext+0x230>
    80001800:	00004097          	auipc	ra,0x4
    80001804:	662080e7          	jalr	1634(ra) # 80005e62 <panic>

0000000080001808 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001808:	7179                	add	sp,sp,-48
    8000180a:	f406                	sd	ra,40(sp)
    8000180c:	f022                	sd	s0,32(sp)
    8000180e:	ec26                	sd	s1,24(sp)
    80001810:	e84a                	sd	s2,16(sp)
    80001812:	e44e                	sd	s3,8(sp)
    80001814:	1800                	add	s0,sp,48
    80001816:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001818:	00007497          	auipc	s1,0x7
    8000181c:	54848493          	add	s1,s1,1352 # 80008d60 <proc>
    80001820:	0000d997          	auipc	s3,0xd
    80001824:	f4098993          	add	s3,s3,-192 # 8000e760 <tickslock>
    acquire(&p->lock);
    80001828:	8526                	mv	a0,s1
    8000182a:	00005097          	auipc	ra,0x5
    8000182e:	bb2080e7          	jalr	-1102(ra) # 800063dc <acquire>
    if(p->pid == pid){
    80001832:	589c                	lw	a5,48(s1)
    80001834:	01278d63          	beq	a5,s2,8000184e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001838:	8526                	mv	a0,s1
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	c56080e7          	jalr	-938(ra) # 80006490 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001842:	16848493          	add	s1,s1,360
    80001846:	ff3491e3          	bne	s1,s3,80001828 <kill+0x20>
  }
  return -1;
    8000184a:	557d                	li	a0,-1
    8000184c:	a829                	j	80001866 <kill+0x5e>
      p->killed = 1;
    8000184e:	4785                	li	a5,1
    80001850:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001852:	4c98                	lw	a4,24(s1)
    80001854:	4789                	li	a5,2
    80001856:	00f70f63          	beq	a4,a5,80001874 <kill+0x6c>
      release(&p->lock);
    8000185a:	8526                	mv	a0,s1
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	c34080e7          	jalr	-972(ra) # 80006490 <release>
      return 0;
    80001864:	4501                	li	a0,0
}
    80001866:	70a2                	ld	ra,40(sp)
    80001868:	7402                	ld	s0,32(sp)
    8000186a:	64e2                	ld	s1,24(sp)
    8000186c:	6942                	ld	s2,16(sp)
    8000186e:	69a2                	ld	s3,8(sp)
    80001870:	6145                	add	sp,sp,48
    80001872:	8082                	ret
        p->state = RUNNABLE;
    80001874:	478d                	li	a5,3
    80001876:	cc9c                	sw	a5,24(s1)
    80001878:	b7cd                	j	8000185a <kill+0x52>

000000008000187a <setkilled>:

void
setkilled(struct proc *p)
{
    8000187a:	1101                	add	sp,sp,-32
    8000187c:	ec06                	sd	ra,24(sp)
    8000187e:	e822                	sd	s0,16(sp)
    80001880:	e426                	sd	s1,8(sp)
    80001882:	1000                	add	s0,sp,32
    80001884:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	b56080e7          	jalr	-1194(ra) # 800063dc <acquire>
  p->killed = 1;
    8000188e:	4785                	li	a5,1
    80001890:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001892:	8526                	mv	a0,s1
    80001894:	00005097          	auipc	ra,0x5
    80001898:	bfc080e7          	jalr	-1028(ra) # 80006490 <release>
}
    8000189c:	60e2                	ld	ra,24(sp)
    8000189e:	6442                	ld	s0,16(sp)
    800018a0:	64a2                	ld	s1,8(sp)
    800018a2:	6105                	add	sp,sp,32
    800018a4:	8082                	ret

00000000800018a6 <killed>:

int
killed(struct proc *p)
{
    800018a6:	1101                	add	sp,sp,-32
    800018a8:	ec06                	sd	ra,24(sp)
    800018aa:	e822                	sd	s0,16(sp)
    800018ac:	e426                	sd	s1,8(sp)
    800018ae:	e04a                	sd	s2,0(sp)
    800018b0:	1000                	add	s0,sp,32
    800018b2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	b28080e7          	jalr	-1240(ra) # 800063dc <acquire>
  k = p->killed;
    800018bc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800018c0:	8526                	mv	a0,s1
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	bce080e7          	jalr	-1074(ra) # 80006490 <release>
  return k;
}
    800018ca:	854a                	mv	a0,s2
    800018cc:	60e2                	ld	ra,24(sp)
    800018ce:	6442                	ld	s0,16(sp)
    800018d0:	64a2                	ld	s1,8(sp)
    800018d2:	6902                	ld	s2,0(sp)
    800018d4:	6105                	add	sp,sp,32
    800018d6:	8082                	ret

00000000800018d8 <wait>:
{
    800018d8:	715d                	add	sp,sp,-80
    800018da:	e486                	sd	ra,72(sp)
    800018dc:	e0a2                	sd	s0,64(sp)
    800018de:	fc26                	sd	s1,56(sp)
    800018e0:	f84a                	sd	s2,48(sp)
    800018e2:	f44e                	sd	s3,40(sp)
    800018e4:	f052                	sd	s4,32(sp)
    800018e6:	ec56                	sd	s5,24(sp)
    800018e8:	e85a                	sd	s6,16(sp)
    800018ea:	e45e                	sd	s7,8(sp)
    800018ec:	e062                	sd	s8,0(sp)
    800018ee:	0880                	add	s0,sp,80
    800018f0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	65e080e7          	jalr	1630(ra) # 80000f50 <myproc>
    800018fa:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018fc:	00007517          	auipc	a0,0x7
    80001900:	04c50513          	add	a0,a0,76 # 80008948 <wait_lock>
    80001904:	00005097          	auipc	ra,0x5
    80001908:	ad8080e7          	jalr	-1320(ra) # 800063dc <acquire>
    havekids = 0;
    8000190c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000190e:	4a15                	li	s4,5
        havekids = 1;
    80001910:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001912:	0000d997          	auipc	s3,0xd
    80001916:	e4e98993          	add	s3,s3,-434 # 8000e760 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000191a:	00007c17          	auipc	s8,0x7
    8000191e:	02ec0c13          	add	s8,s8,46 # 80008948 <wait_lock>
    80001922:	a0d1                	j	800019e6 <wait+0x10e>
          pid = pp->pid;
    80001924:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001928:	000b0e63          	beqz	s6,80001944 <wait+0x6c>
    8000192c:	4691                	li	a3,4
    8000192e:	02c48613          	add	a2,s1,44
    80001932:	85da                	mv	a1,s6
    80001934:	05093503          	ld	a0,80(s2)
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	25e080e7          	jalr	606(ra) # 80000b96 <copyout>
    80001940:	04054163          	bltz	a0,80001982 <wait+0xaa>
          freeproc(pp);
    80001944:	8526                	mv	a0,s1
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	7c0080e7          	jalr	1984(ra) # 80001106 <freeproc>
          release(&pp->lock);
    8000194e:	8526                	mv	a0,s1
    80001950:	00005097          	auipc	ra,0x5
    80001954:	b40080e7          	jalr	-1216(ra) # 80006490 <release>
          release(&wait_lock);
    80001958:	00007517          	auipc	a0,0x7
    8000195c:	ff050513          	add	a0,a0,-16 # 80008948 <wait_lock>
    80001960:	00005097          	auipc	ra,0x5
    80001964:	b30080e7          	jalr	-1232(ra) # 80006490 <release>
}
    80001968:	854e                	mv	a0,s3
    8000196a:	60a6                	ld	ra,72(sp)
    8000196c:	6406                	ld	s0,64(sp)
    8000196e:	74e2                	ld	s1,56(sp)
    80001970:	7942                	ld	s2,48(sp)
    80001972:	79a2                	ld	s3,40(sp)
    80001974:	7a02                	ld	s4,32(sp)
    80001976:	6ae2                	ld	s5,24(sp)
    80001978:	6b42                	ld	s6,16(sp)
    8000197a:	6ba2                	ld	s7,8(sp)
    8000197c:	6c02                	ld	s8,0(sp)
    8000197e:	6161                	add	sp,sp,80
    80001980:	8082                	ret
            release(&pp->lock);
    80001982:	8526                	mv	a0,s1
    80001984:	00005097          	auipc	ra,0x5
    80001988:	b0c080e7          	jalr	-1268(ra) # 80006490 <release>
            release(&wait_lock);
    8000198c:	00007517          	auipc	a0,0x7
    80001990:	fbc50513          	add	a0,a0,-68 # 80008948 <wait_lock>
    80001994:	00005097          	auipc	ra,0x5
    80001998:	afc080e7          	jalr	-1284(ra) # 80006490 <release>
            return -1;
    8000199c:	59fd                	li	s3,-1
    8000199e:	b7e9                	j	80001968 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019a0:	16848493          	add	s1,s1,360
    800019a4:	03348463          	beq	s1,s3,800019cc <wait+0xf4>
      if(pp->parent == p){
    800019a8:	7c9c                	ld	a5,56(s1)
    800019aa:	ff279be3          	bne	a5,s2,800019a0 <wait+0xc8>
        acquire(&pp->lock);
    800019ae:	8526                	mv	a0,s1
    800019b0:	00005097          	auipc	ra,0x5
    800019b4:	a2c080e7          	jalr	-1492(ra) # 800063dc <acquire>
        if(pp->state == ZOMBIE){
    800019b8:	4c9c                	lw	a5,24(s1)
    800019ba:	f74785e3          	beq	a5,s4,80001924 <wait+0x4c>
        release(&pp->lock);
    800019be:	8526                	mv	a0,s1
    800019c0:	00005097          	auipc	ra,0x5
    800019c4:	ad0080e7          	jalr	-1328(ra) # 80006490 <release>
        havekids = 1;
    800019c8:	8756                	mv	a4,s5
    800019ca:	bfd9                	j	800019a0 <wait+0xc8>
    if(!havekids || killed(p)){
    800019cc:	c31d                	beqz	a4,800019f2 <wait+0x11a>
    800019ce:	854a                	mv	a0,s2
    800019d0:	00000097          	auipc	ra,0x0
    800019d4:	ed6080e7          	jalr	-298(ra) # 800018a6 <killed>
    800019d8:	ed09                	bnez	a0,800019f2 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019da:	85e2                	mv	a1,s8
    800019dc:	854a                	mv	a0,s2
    800019de:	00000097          	auipc	ra,0x0
    800019e2:	c20080e7          	jalr	-992(ra) # 800015fe <sleep>
    havekids = 0;
    800019e6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019e8:	00007497          	auipc	s1,0x7
    800019ec:	37848493          	add	s1,s1,888 # 80008d60 <proc>
    800019f0:	bf65                	j	800019a8 <wait+0xd0>
      release(&wait_lock);
    800019f2:	00007517          	auipc	a0,0x7
    800019f6:	f5650513          	add	a0,a0,-170 # 80008948 <wait_lock>
    800019fa:	00005097          	auipc	ra,0x5
    800019fe:	a96080e7          	jalr	-1386(ra) # 80006490 <release>
      return -1;
    80001a02:	59fd                	li	s3,-1
    80001a04:	b795                	j	80001968 <wait+0x90>

0000000080001a06 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a06:	7179                	add	sp,sp,-48
    80001a08:	f406                	sd	ra,40(sp)
    80001a0a:	f022                	sd	s0,32(sp)
    80001a0c:	ec26                	sd	s1,24(sp)
    80001a0e:	e84a                	sd	s2,16(sp)
    80001a10:	e44e                	sd	s3,8(sp)
    80001a12:	e052                	sd	s4,0(sp)
    80001a14:	1800                	add	s0,sp,48
    80001a16:	84aa                	mv	s1,a0
    80001a18:	892e                	mv	s2,a1
    80001a1a:	89b2                	mv	s3,a2
    80001a1c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	532080e7          	jalr	1330(ra) # 80000f50 <myproc>
  if(user_dst){
    80001a26:	c08d                	beqz	s1,80001a48 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a28:	86d2                	mv	a3,s4
    80001a2a:	864e                	mv	a2,s3
    80001a2c:	85ca                	mv	a1,s2
    80001a2e:	6928                	ld	a0,80(a0)
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	166080e7          	jalr	358(ra) # 80000b96 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a38:	70a2                	ld	ra,40(sp)
    80001a3a:	7402                	ld	s0,32(sp)
    80001a3c:	64e2                	ld	s1,24(sp)
    80001a3e:	6942                	ld	s2,16(sp)
    80001a40:	69a2                	ld	s3,8(sp)
    80001a42:	6a02                	ld	s4,0(sp)
    80001a44:	6145                	add	sp,sp,48
    80001a46:	8082                	ret
    memmove((char *)dst, src, len);
    80001a48:	000a061b          	sext.w	a2,s4
    80001a4c:	85ce                	mv	a1,s3
    80001a4e:	854a                	mv	a0,s2
    80001a50:	ffffe097          	auipc	ra,0xffffe
    80001a54:	7d0080e7          	jalr	2000(ra) # 80000220 <memmove>
    return 0;
    80001a58:	8526                	mv	a0,s1
    80001a5a:	bff9                	j	80001a38 <either_copyout+0x32>

0000000080001a5c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a5c:	7179                	add	sp,sp,-48
    80001a5e:	f406                	sd	ra,40(sp)
    80001a60:	f022                	sd	s0,32(sp)
    80001a62:	ec26                	sd	s1,24(sp)
    80001a64:	e84a                	sd	s2,16(sp)
    80001a66:	e44e                	sd	s3,8(sp)
    80001a68:	e052                	sd	s4,0(sp)
    80001a6a:	1800                	add	s0,sp,48
    80001a6c:	892a                	mv	s2,a0
    80001a6e:	84ae                	mv	s1,a1
    80001a70:	89b2                	mv	s3,a2
    80001a72:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a74:	fffff097          	auipc	ra,0xfffff
    80001a78:	4dc080e7          	jalr	1244(ra) # 80000f50 <myproc>
  if(user_src){
    80001a7c:	c08d                	beqz	s1,80001a9e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a7e:	86d2                	mv	a3,s4
    80001a80:	864e                	mv	a2,s3
    80001a82:	85ca                	mv	a1,s2
    80001a84:	6928                	ld	a0,80(a0)
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	1ee080e7          	jalr	494(ra) # 80000c74 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a8e:	70a2                	ld	ra,40(sp)
    80001a90:	7402                	ld	s0,32(sp)
    80001a92:	64e2                	ld	s1,24(sp)
    80001a94:	6942                	ld	s2,16(sp)
    80001a96:	69a2                	ld	s3,8(sp)
    80001a98:	6a02                	ld	s4,0(sp)
    80001a9a:	6145                	add	sp,sp,48
    80001a9c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a9e:	000a061b          	sext.w	a2,s4
    80001aa2:	85ce                	mv	a1,s3
    80001aa4:	854a                	mv	a0,s2
    80001aa6:	ffffe097          	auipc	ra,0xffffe
    80001aaa:	77a080e7          	jalr	1914(ra) # 80000220 <memmove>
    return 0;
    80001aae:	8526                	mv	a0,s1
    80001ab0:	bff9                	j	80001a8e <either_copyin+0x32>

0000000080001ab2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ab2:	715d                	add	sp,sp,-80
    80001ab4:	e486                	sd	ra,72(sp)
    80001ab6:	e0a2                	sd	s0,64(sp)
    80001ab8:	fc26                	sd	s1,56(sp)
    80001aba:	f84a                	sd	s2,48(sp)
    80001abc:	f44e                	sd	s3,40(sp)
    80001abe:	f052                	sd	s4,32(sp)
    80001ac0:	ec56                	sd	s5,24(sp)
    80001ac2:	e85a                	sd	s6,16(sp)
    80001ac4:	e45e                	sd	s7,8(sp)
    80001ac6:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ac8:	00006517          	auipc	a0,0x6
    80001acc:	55050513          	add	a0,a0,1360 # 80008018 <etext+0x18>
    80001ad0:	00004097          	auipc	ra,0x4
    80001ad4:	3dc080e7          	jalr	988(ra) # 80005eac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ad8:	00007497          	auipc	s1,0x7
    80001adc:	3e048493          	add	s1,s1,992 # 80008eb8 <proc+0x158>
    80001ae0:	0000d917          	auipc	s2,0xd
    80001ae4:	dd890913          	add	s2,s2,-552 # 8000e8b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aea:	00006997          	auipc	s3,0x6
    80001aee:	75698993          	add	s3,s3,1878 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001af2:	00006a97          	auipc	s5,0x6
    80001af6:	756a8a93          	add	s5,s5,1878 # 80008248 <etext+0x248>
    printf("\n");
    80001afa:	00006a17          	auipc	s4,0x6
    80001afe:	51ea0a13          	add	s4,s4,1310 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b02:	00007b97          	auipc	s7,0x7
    80001b06:	c6eb8b93          	add	s7,s7,-914 # 80008770 <states.0>
    80001b0a:	a00d                	j	80001b2c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b0c:	ed86a583          	lw	a1,-296(a3)
    80001b10:	8556                	mv	a0,s5
    80001b12:	00004097          	auipc	ra,0x4
    80001b16:	39a080e7          	jalr	922(ra) # 80005eac <printf>
    printf("\n");
    80001b1a:	8552                	mv	a0,s4
    80001b1c:	00004097          	auipc	ra,0x4
    80001b20:	390080e7          	jalr	912(ra) # 80005eac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b24:	16848493          	add	s1,s1,360
    80001b28:	03248263          	beq	s1,s2,80001b4c <procdump+0x9a>
    if(p->state == UNUSED)
    80001b2c:	86a6                	mv	a3,s1
    80001b2e:	ec04a783          	lw	a5,-320(s1)
    80001b32:	dbed                	beqz	a5,80001b24 <procdump+0x72>
      state = "???";
    80001b34:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b36:	fcfb6be3          	bltu	s6,a5,80001b0c <procdump+0x5a>
    80001b3a:	02079713          	sll	a4,a5,0x20
    80001b3e:	01d75793          	srl	a5,a4,0x1d
    80001b42:	97de                	add	a5,a5,s7
    80001b44:	6390                	ld	a2,0(a5)
    80001b46:	f279                	bnez	a2,80001b0c <procdump+0x5a>
      state = "???";
    80001b48:	864e                	mv	a2,s3
    80001b4a:	b7c9                	j	80001b0c <procdump+0x5a>
  }
}
    80001b4c:	60a6                	ld	ra,72(sp)
    80001b4e:	6406                	ld	s0,64(sp)
    80001b50:	74e2                	ld	s1,56(sp)
    80001b52:	7942                	ld	s2,48(sp)
    80001b54:	79a2                	ld	s3,40(sp)
    80001b56:	7a02                	ld	s4,32(sp)
    80001b58:	6ae2                	ld	s5,24(sp)
    80001b5a:	6b42                	ld	s6,16(sp)
    80001b5c:	6ba2                	ld	s7,8(sp)
    80001b5e:	6161                	add	sp,sp,80
    80001b60:	8082                	ret

0000000080001b62 <count_proc>:
  return 0;
}

uint64
count_proc(void)
{
    80001b62:	1141                	add	sp,sp,-16
    80001b64:	e422                	sd	s0,8(sp)
    80001b66:	0800                	add	s0,sp,16
  uint64 cnt = 0;
  for (int i = 0; i < NPROC; ++i) {
    80001b68:	00007797          	auipc	a5,0x7
    80001b6c:	21078793          	add	a5,a5,528 # 80008d78 <proc+0x18>
    80001b70:	0000d697          	auipc	a3,0xd
    80001b74:	c0868693          	add	a3,a3,-1016 # 8000e778 <bcache>
  uint64 cnt = 0;
    80001b78:	4501                	li	a0,0
    if (proc[i].state != UNUSED) {
    80001b7a:	4398                	lw	a4,0(a5)
      cnt++;
    80001b7c:	00e03733          	snez	a4,a4
    80001b80:	953a                	add	a0,a0,a4
  for (int i = 0; i < NPROC; ++i) {
    80001b82:	16878793          	add	a5,a5,360
    80001b86:	fed79ae3          	bne	a5,a3,80001b7a <count_proc+0x18>
    }
  }
  return cnt;
    80001b8a:	6422                	ld	s0,8(sp)
    80001b8c:	0141                	add	sp,sp,16
    80001b8e:	8082                	ret

0000000080001b90 <sys_info>:
{
    80001b90:	7179                	add	sp,sp,-48
    80001b92:	f406                	sd	ra,40(sp)
    80001b94:	f022                	sd	s0,32(sp)
    80001b96:	1800                	add	s0,sp,48
  argaddr(0, &addr);
    80001b98:	fe840593          	add	a1,s0,-24
    80001b9c:	4501                	li	a0,0
    80001b9e:	00000097          	auipc	ra,0x0
    80001ba2:	578080e7          	jalr	1400(ra) # 80002116 <argaddr>
  sinfo.freemem = freemem_size();
    80001ba6:	ffffe097          	auipc	ra,0xffffe
    80001baa:	5d4080e7          	jalr	1492(ra) # 8000017a <freemem_size>
    80001bae:	fca43c23          	sd	a0,-40(s0)
  sinfo.nproc = count_proc();
    80001bb2:	00000097          	auipc	ra,0x0
    80001bb6:	fb0080e7          	jalr	-80(ra) # 80001b62 <count_proc>
    80001bba:	fea43023          	sd	a0,-32(s0)
  if (copyout(myproc()->pagetable, addr, (char *)&sinfo, sizeof(sinfo)) < 0)
    80001bbe:	fffff097          	auipc	ra,0xfffff
    80001bc2:	392080e7          	jalr	914(ra) # 80000f50 <myproc>
    80001bc6:	46c1                	li	a3,16
    80001bc8:	fd840613          	add	a2,s0,-40
    80001bcc:	fe843583          	ld	a1,-24(s0)
    80001bd0:	6928                	ld	a0,80(a0)
    80001bd2:	fffff097          	auipc	ra,0xfffff
    80001bd6:	fc4080e7          	jalr	-60(ra) # 80000b96 <copyout>
}
    80001bda:	957d                	sra	a0,a0,0x3f
    80001bdc:	70a2                	ld	ra,40(sp)
    80001bde:	7402                	ld	s0,32(sp)
    80001be0:	6145                	add	sp,sp,48
    80001be2:	8082                	ret

0000000080001be4 <swtch>:
    80001be4:	00153023          	sd	ra,0(a0)
    80001be8:	00253423          	sd	sp,8(a0)
    80001bec:	e900                	sd	s0,16(a0)
    80001bee:	ed04                	sd	s1,24(a0)
    80001bf0:	03253023          	sd	s2,32(a0)
    80001bf4:	03353423          	sd	s3,40(a0)
    80001bf8:	03453823          	sd	s4,48(a0)
    80001bfc:	03553c23          	sd	s5,56(a0)
    80001c00:	05653023          	sd	s6,64(a0)
    80001c04:	05753423          	sd	s7,72(a0)
    80001c08:	05853823          	sd	s8,80(a0)
    80001c0c:	05953c23          	sd	s9,88(a0)
    80001c10:	07a53023          	sd	s10,96(a0)
    80001c14:	07b53423          	sd	s11,104(a0)
    80001c18:	0005b083          	ld	ra,0(a1)
    80001c1c:	0085b103          	ld	sp,8(a1)
    80001c20:	6980                	ld	s0,16(a1)
    80001c22:	6d84                	ld	s1,24(a1)
    80001c24:	0205b903          	ld	s2,32(a1)
    80001c28:	0285b983          	ld	s3,40(a1)
    80001c2c:	0305ba03          	ld	s4,48(a1)
    80001c30:	0385ba83          	ld	s5,56(a1)
    80001c34:	0405bb03          	ld	s6,64(a1)
    80001c38:	0485bb83          	ld	s7,72(a1)
    80001c3c:	0505bc03          	ld	s8,80(a1)
    80001c40:	0585bc83          	ld	s9,88(a1)
    80001c44:	0605bd03          	ld	s10,96(a1)
    80001c48:	0685bd83          	ld	s11,104(a1)
    80001c4c:	8082                	ret

0000000080001c4e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c4e:	1141                	add	sp,sp,-16
    80001c50:	e406                	sd	ra,8(sp)
    80001c52:	e022                	sd	s0,0(sp)
    80001c54:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80001c56:	00006597          	auipc	a1,0x6
    80001c5a:	63258593          	add	a1,a1,1586 # 80008288 <etext+0x288>
    80001c5e:	0000d517          	auipc	a0,0xd
    80001c62:	b0250513          	add	a0,a0,-1278 # 8000e760 <tickslock>
    80001c66:	00004097          	auipc	ra,0x4
    80001c6a:	6e6080e7          	jalr	1766(ra) # 8000634c <initlock>
}
    80001c6e:	60a2                	ld	ra,8(sp)
    80001c70:	6402                	ld	s0,0(sp)
    80001c72:	0141                	add	sp,sp,16
    80001c74:	8082                	ret

0000000080001c76 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c76:	1141                	add	sp,sp,-16
    80001c78:	e422                	sd	s0,8(sp)
    80001c7a:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c7c:	00003797          	auipc	a5,0x3
    80001c80:	5b478793          	add	a5,a5,1460 # 80005230 <kernelvec>
    80001c84:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c88:	6422                	ld	s0,8(sp)
    80001c8a:	0141                	add	sp,sp,16
    80001c8c:	8082                	ret

0000000080001c8e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c8e:	1141                	add	sp,sp,-16
    80001c90:	e406                	sd	ra,8(sp)
    80001c92:	e022                	sd	s0,0(sp)
    80001c94:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	2ba080e7          	jalr	698(ra) # 80000f50 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ca2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ca4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ca8:	00005697          	auipc	a3,0x5
    80001cac:	35868693          	add	a3,a3,856 # 80007000 <_trampoline>
    80001cb0:	00005717          	auipc	a4,0x5
    80001cb4:	35070713          	add	a4,a4,848 # 80007000 <_trampoline>
    80001cb8:	8f15                	sub	a4,a4,a3
    80001cba:	040007b7          	lui	a5,0x4000
    80001cbe:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cc0:	07b2                	sll	a5,a5,0xc
    80001cc2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cc8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cca:	18002673          	csrr	a2,satp
    80001cce:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cd0:	6d30                	ld	a2,88(a0)
    80001cd2:	6138                	ld	a4,64(a0)
    80001cd4:	6585                	lui	a1,0x1
    80001cd6:	972e                	add	a4,a4,a1
    80001cd8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cda:	6d38                	ld	a4,88(a0)
    80001cdc:	00000617          	auipc	a2,0x0
    80001ce0:	13860613          	add	a2,a2,312 # 80001e14 <usertrap>
    80001ce4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ce6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ce8:	8612                	mv	a2,tp
    80001cea:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cf0:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cf4:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cfe:	6f18                	ld	a4,24(a4)
    80001d00:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d04:	6928                	ld	a0,80(a0)
    80001d06:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d08:	00005717          	auipc	a4,0x5
    80001d0c:	39470713          	add	a4,a4,916 # 8000709c <userret>
    80001d10:	8f15                	sub	a4,a4,a3
    80001d12:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d14:	577d                	li	a4,-1
    80001d16:	177e                	sll	a4,a4,0x3f
    80001d18:	8d59                	or	a0,a0,a4
    80001d1a:	9782                	jalr	a5
}
    80001d1c:	60a2                	ld	ra,8(sp)
    80001d1e:	6402                	ld	s0,0(sp)
    80001d20:	0141                	add	sp,sp,16
    80001d22:	8082                	ret

0000000080001d24 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d24:	1101                	add	sp,sp,-32
    80001d26:	ec06                	sd	ra,24(sp)
    80001d28:	e822                	sd	s0,16(sp)
    80001d2a:	e426                	sd	s1,8(sp)
    80001d2c:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80001d2e:	0000d497          	auipc	s1,0xd
    80001d32:	a3248493          	add	s1,s1,-1486 # 8000e760 <tickslock>
    80001d36:	8526                	mv	a0,s1
    80001d38:	00004097          	auipc	ra,0x4
    80001d3c:	6a4080e7          	jalr	1700(ra) # 800063dc <acquire>
  ticks++;
    80001d40:	00007517          	auipc	a0,0x7
    80001d44:	bb850513          	add	a0,a0,-1096 # 800088f8 <ticks>
    80001d48:	411c                	lw	a5,0(a0)
    80001d4a:	2785                	addw	a5,a5,1
    80001d4c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	914080e7          	jalr	-1772(ra) # 80001662 <wakeup>
  release(&tickslock);
    80001d56:	8526                	mv	a0,s1
    80001d58:	00004097          	auipc	ra,0x4
    80001d5c:	738080e7          	jalr	1848(ra) # 80006490 <release>
}
    80001d60:	60e2                	ld	ra,24(sp)
    80001d62:	6442                	ld	s0,16(sp)
    80001d64:	64a2                	ld	s1,8(sp)
    80001d66:	6105                	add	sp,sp,32
    80001d68:	8082                	ret

0000000080001d6a <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d6a:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d6e:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001d70:	0a07d163          	bgez	a5,80001e12 <devintr+0xa8>
{
    80001d74:	1101                	add	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80001d7c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001d80:	46a5                	li	a3,9
    80001d82:	00d70c63          	beq	a4,a3,80001d9a <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001d86:	577d                	li	a4,-1
    80001d88:	177e                	sll	a4,a4,0x3f
    80001d8a:	0705                	add	a4,a4,1
    return 0;
    80001d8c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d8e:	06e78163          	beq	a5,a4,80001df0 <devintr+0x86>
  }
}
    80001d92:	60e2                	ld	ra,24(sp)
    80001d94:	6442                	ld	s0,16(sp)
    80001d96:	6105                	add	sp,sp,32
    80001d98:	8082                	ret
    80001d9a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d9c:	00003097          	auipc	ra,0x3
    80001da0:	5a0080e7          	jalr	1440(ra) # 8000533c <plic_claim>
    80001da4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001da6:	47a9                	li	a5,10
    80001da8:	00f50963          	beq	a0,a5,80001dba <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001dac:	4785                	li	a5,1
    80001dae:	00f50b63          	beq	a0,a5,80001dc4 <devintr+0x5a>
    return 1;
    80001db2:	4505                	li	a0,1
    } else if(irq){
    80001db4:	ec89                	bnez	s1,80001dce <devintr+0x64>
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	bfe9                	j	80001d92 <devintr+0x28>
      uartintr();
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	542080e7          	jalr	1346(ra) # 800062fc <uartintr>
    if(irq)
    80001dc2:	a839                	j	80001de0 <devintr+0x76>
      virtio_disk_intr();
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	aa2080e7          	jalr	-1374(ra) # 80005866 <virtio_disk_intr>
    if(irq)
    80001dcc:	a811                	j	80001de0 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dce:	85a6                	mv	a1,s1
    80001dd0:	00006517          	auipc	a0,0x6
    80001dd4:	4c050513          	add	a0,a0,1216 # 80008290 <etext+0x290>
    80001dd8:	00004097          	auipc	ra,0x4
    80001ddc:	0d4080e7          	jalr	212(ra) # 80005eac <printf>
      plic_complete(irq);
    80001de0:	8526                	mv	a0,s1
    80001de2:	00003097          	auipc	ra,0x3
    80001de6:	57e080e7          	jalr	1406(ra) # 80005360 <plic_complete>
    return 1;
    80001dea:	4505                	li	a0,1
    80001dec:	64a2                	ld	s1,8(sp)
    80001dee:	b755                	j	80001d92 <devintr+0x28>
    if(cpuid() == 0){
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	134080e7          	jalr	308(ra) # 80000f24 <cpuid>
    80001df8:	c901                	beqz	a0,80001e08 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dfa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dfe:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e00:	14479073          	csrw	sip,a5
    return 2;
    80001e04:	4509                	li	a0,2
    80001e06:	b771                	j	80001d92 <devintr+0x28>
      clockintr();
    80001e08:	00000097          	auipc	ra,0x0
    80001e0c:	f1c080e7          	jalr	-228(ra) # 80001d24 <clockintr>
    80001e10:	b7ed                	j	80001dfa <devintr+0x90>
}
    80001e12:	8082                	ret

0000000080001e14 <usertrap>:
{
    80001e14:	1101                	add	sp,sp,-32
    80001e16:	ec06                	sd	ra,24(sp)
    80001e18:	e822                	sd	s0,16(sp)
    80001e1a:	e426                	sd	s1,8(sp)
    80001e1c:	e04a                	sd	s2,0(sp)
    80001e1e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e20:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e24:	1007f793          	and	a5,a5,256
    80001e28:	e3b1                	bnez	a5,80001e6c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e2a:	00003797          	auipc	a5,0x3
    80001e2e:	40678793          	add	a5,a5,1030 # 80005230 <kernelvec>
    80001e32:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	11a080e7          	jalr	282(ra) # 80000f50 <myproc>
    80001e3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e40:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e42:	14102773          	csrr	a4,sepc
    80001e46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e48:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e4c:	47a1                	li	a5,8
    80001e4e:	02f70763          	beq	a4,a5,80001e7c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	f18080e7          	jalr	-232(ra) # 80001d6a <devintr>
    80001e5a:	892a                	mv	s2,a0
    80001e5c:	c151                	beqz	a0,80001ee0 <usertrap+0xcc>
  if(killed(p))
    80001e5e:	8526                	mv	a0,s1
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	a46080e7          	jalr	-1466(ra) # 800018a6 <killed>
    80001e68:	c929                	beqz	a0,80001eba <usertrap+0xa6>
    80001e6a:	a099                	j	80001eb0 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	44450513          	add	a0,a0,1092 # 800082b0 <etext+0x2b0>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	fee080e7          	jalr	-18(ra) # 80005e62 <panic>
    if(killed(p))
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	a2a080e7          	jalr	-1494(ra) # 800018a6 <killed>
    80001e84:	e921                	bnez	a0,80001ed4 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e86:	6cb8                	ld	a4,88(s1)
    80001e88:	6f1c                	ld	a5,24(a4)
    80001e8a:	0791                	add	a5,a5,4
    80001e8c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e92:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e96:	10079073          	csrw	sstatus,a5
    syscall();
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	2d4080e7          	jalr	724(ra) # 8000216e <syscall>
  if(killed(p))
    80001ea2:	8526                	mv	a0,s1
    80001ea4:	00000097          	auipc	ra,0x0
    80001ea8:	a02080e7          	jalr	-1534(ra) # 800018a6 <killed>
    80001eac:	c911                	beqz	a0,80001ec0 <usertrap+0xac>
    80001eae:	4901                	li	s2,0
    exit(-1);
    80001eb0:	557d                	li	a0,-1
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	880080e7          	jalr	-1920(ra) # 80001732 <exit>
  if(which_dev == 2)
    80001eba:	4789                	li	a5,2
    80001ebc:	04f90f63          	beq	s2,a5,80001f1a <usertrap+0x106>
  usertrapret();
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	dce080e7          	jalr	-562(ra) # 80001c8e <usertrapret>
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6902                	ld	s2,0(sp)
    80001ed0:	6105                	add	sp,sp,32
    80001ed2:	8082                	ret
      exit(-1);
    80001ed4:	557d                	li	a0,-1
    80001ed6:	00000097          	auipc	ra,0x0
    80001eda:	85c080e7          	jalr	-1956(ra) # 80001732 <exit>
    80001ede:	b765                	j	80001e86 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ee4:	5890                	lw	a2,48(s1)
    80001ee6:	00006517          	auipc	a0,0x6
    80001eea:	3ea50513          	add	a0,a0,1002 # 800082d0 <etext+0x2d0>
    80001eee:	00004097          	auipc	ra,0x4
    80001ef2:	fbe080e7          	jalr	-66(ra) # 80005eac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001efa:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	40250513          	add	a0,a0,1026 # 80008300 <etext+0x300>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	fa6080e7          	jalr	-90(ra) # 80005eac <printf>
    setkilled(p);
    80001f0e:	8526                	mv	a0,s1
    80001f10:	00000097          	auipc	ra,0x0
    80001f14:	96a080e7          	jalr	-1686(ra) # 8000187a <setkilled>
    80001f18:	b769                	j	80001ea2 <usertrap+0x8e>
    yield();
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	6a8080e7          	jalr	1704(ra) # 800015c2 <yield>
    80001f22:	bf79                	j	80001ec0 <usertrap+0xac>

0000000080001f24 <kerneltrap>:
{
    80001f24:	7179                	add	sp,sp,-48
    80001f26:	f406                	sd	ra,40(sp)
    80001f28:	f022                	sd	s0,32(sp)
    80001f2a:	ec26                	sd	s1,24(sp)
    80001f2c:	e84a                	sd	s2,16(sp)
    80001f2e:	e44e                	sd	s3,8(sp)
    80001f30:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f32:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f36:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f3e:	1004f793          	and	a5,s1,256
    80001f42:	cb85                	beqz	a5,80001f72 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f48:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80001f4a:	ef85                	bnez	a5,80001f82 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f4c:	00000097          	auipc	ra,0x0
    80001f50:	e1e080e7          	jalr	-482(ra) # 80001d6a <devintr>
    80001f54:	cd1d                	beqz	a0,80001f92 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f56:	4789                	li	a5,2
    80001f58:	06f50a63          	beq	a0,a5,80001fcc <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f5c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f60:	10049073          	csrw	sstatus,s1
}
    80001f64:	70a2                	ld	ra,40(sp)
    80001f66:	7402                	ld	s0,32(sp)
    80001f68:	64e2                	ld	s1,24(sp)
    80001f6a:	6942                	ld	s2,16(sp)
    80001f6c:	69a2                	ld	s3,8(sp)
    80001f6e:	6145                	add	sp,sp,48
    80001f70:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f72:	00006517          	auipc	a0,0x6
    80001f76:	3ae50513          	add	a0,a0,942 # 80008320 <etext+0x320>
    80001f7a:	00004097          	auipc	ra,0x4
    80001f7e:	ee8080e7          	jalr	-280(ra) # 80005e62 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f82:	00006517          	auipc	a0,0x6
    80001f86:	3c650513          	add	a0,a0,966 # 80008348 <etext+0x348>
    80001f8a:	00004097          	auipc	ra,0x4
    80001f8e:	ed8080e7          	jalr	-296(ra) # 80005e62 <panic>
    printf("scause %p\n", scause);
    80001f92:	85ce                	mv	a1,s3
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	3d450513          	add	a0,a0,980 # 80008368 <etext+0x368>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	f10080e7          	jalr	-240(ra) # 80005eac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fa4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fa8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fac:	00006517          	auipc	a0,0x6
    80001fb0:	3cc50513          	add	a0,a0,972 # 80008378 <etext+0x378>
    80001fb4:	00004097          	auipc	ra,0x4
    80001fb8:	ef8080e7          	jalr	-264(ra) # 80005eac <printf>
    panic("kerneltrap");
    80001fbc:	00006517          	auipc	a0,0x6
    80001fc0:	3d450513          	add	a0,a0,980 # 80008390 <etext+0x390>
    80001fc4:	00004097          	auipc	ra,0x4
    80001fc8:	e9e080e7          	jalr	-354(ra) # 80005e62 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fcc:	fffff097          	auipc	ra,0xfffff
    80001fd0:	f84080e7          	jalr	-124(ra) # 80000f50 <myproc>
    80001fd4:	d541                	beqz	a0,80001f5c <kerneltrap+0x38>
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	f7a080e7          	jalr	-134(ra) # 80000f50 <myproc>
    80001fde:	4d18                	lw	a4,24(a0)
    80001fe0:	4791                	li	a5,4
    80001fe2:	f6f71de3          	bne	a4,a5,80001f5c <kerneltrap+0x38>
    yield();
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	5dc080e7          	jalr	1500(ra) # 800015c2 <yield>
    80001fee:	b7bd                	j	80001f5c <kerneltrap+0x38>

0000000080001ff0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ff0:	1101                	add	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	1000                	add	s0,sp,32
    80001ffa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	f54080e7          	jalr	-172(ra) # 80000f50 <myproc>
  switch (n) {
    80002004:	4795                	li	a5,5
    80002006:	0497e163          	bltu	a5,s1,80002048 <argraw+0x58>
    8000200a:	048a                	sll	s1,s1,0x2
    8000200c:	00006717          	auipc	a4,0x6
    80002010:	79470713          	add	a4,a4,1940 # 800087a0 <states.0+0x30>
    80002014:	94ba                	add	s1,s1,a4
    80002016:	409c                	lw	a5,0(s1)
    80002018:	97ba                	add	a5,a5,a4
    8000201a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000201c:	6d3c                	ld	a5,88(a0)
    8000201e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002020:	60e2                	ld	ra,24(sp)
    80002022:	6442                	ld	s0,16(sp)
    80002024:	64a2                	ld	s1,8(sp)
    80002026:	6105                	add	sp,sp,32
    80002028:	8082                	ret
    return p->trapframe->a1;
    8000202a:	6d3c                	ld	a5,88(a0)
    8000202c:	7fa8                	ld	a0,120(a5)
    8000202e:	bfcd                	j	80002020 <argraw+0x30>
    return p->trapframe->a2;
    80002030:	6d3c                	ld	a5,88(a0)
    80002032:	63c8                	ld	a0,128(a5)
    80002034:	b7f5                	j	80002020 <argraw+0x30>
    return p->trapframe->a3;
    80002036:	6d3c                	ld	a5,88(a0)
    80002038:	67c8                	ld	a0,136(a5)
    8000203a:	b7dd                	j	80002020 <argraw+0x30>
    return p->trapframe->a4;
    8000203c:	6d3c                	ld	a5,88(a0)
    8000203e:	6bc8                	ld	a0,144(a5)
    80002040:	b7c5                	j	80002020 <argraw+0x30>
    return p->trapframe->a5;
    80002042:	6d3c                	ld	a5,88(a0)
    80002044:	6fc8                	ld	a0,152(a5)
    80002046:	bfe9                	j	80002020 <argraw+0x30>
  panic("argraw");
    80002048:	00006517          	auipc	a0,0x6
    8000204c:	35850513          	add	a0,a0,856 # 800083a0 <etext+0x3a0>
    80002050:	00004097          	auipc	ra,0x4
    80002054:	e12080e7          	jalr	-494(ra) # 80005e62 <panic>

0000000080002058 <fetchaddr>:
{
    80002058:	1101                	add	sp,sp,-32
    8000205a:	ec06                	sd	ra,24(sp)
    8000205c:	e822                	sd	s0,16(sp)
    8000205e:	e426                	sd	s1,8(sp)
    80002060:	e04a                	sd	s2,0(sp)
    80002062:	1000                	add	s0,sp,32
    80002064:	84aa                	mv	s1,a0
    80002066:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	ee8080e7          	jalr	-280(ra) # 80000f50 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002070:	653c                	ld	a5,72(a0)
    80002072:	02f4f863          	bgeu	s1,a5,800020a2 <fetchaddr+0x4a>
    80002076:	00848713          	add	a4,s1,8
    8000207a:	02e7e663          	bltu	a5,a4,800020a6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000207e:	46a1                	li	a3,8
    80002080:	8626                	mv	a2,s1
    80002082:	85ca                	mv	a1,s2
    80002084:	6928                	ld	a0,80(a0)
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	bee080e7          	jalr	-1042(ra) # 80000c74 <copyin>
    8000208e:	00a03533          	snez	a0,a0
    80002092:	40a00533          	neg	a0,a0
}
    80002096:	60e2                	ld	ra,24(sp)
    80002098:	6442                	ld	s0,16(sp)
    8000209a:	64a2                	ld	s1,8(sp)
    8000209c:	6902                	ld	s2,0(sp)
    8000209e:	6105                	add	sp,sp,32
    800020a0:	8082                	ret
    return -1;
    800020a2:	557d                	li	a0,-1
    800020a4:	bfcd                	j	80002096 <fetchaddr+0x3e>
    800020a6:	557d                	li	a0,-1
    800020a8:	b7fd                	j	80002096 <fetchaddr+0x3e>

00000000800020aa <fetchstr>:
{
    800020aa:	7179                	add	sp,sp,-48
    800020ac:	f406                	sd	ra,40(sp)
    800020ae:	f022                	sd	s0,32(sp)
    800020b0:	ec26                	sd	s1,24(sp)
    800020b2:	e84a                	sd	s2,16(sp)
    800020b4:	e44e                	sd	s3,8(sp)
    800020b6:	1800                	add	s0,sp,48
    800020b8:	892a                	mv	s2,a0
    800020ba:	84ae                	mv	s1,a1
    800020bc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020be:	fffff097          	auipc	ra,0xfffff
    800020c2:	e92080e7          	jalr	-366(ra) # 80000f50 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020c6:	86ce                	mv	a3,s3
    800020c8:	864a                	mv	a2,s2
    800020ca:	85a6                	mv	a1,s1
    800020cc:	6928                	ld	a0,80(a0)
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	c34080e7          	jalr	-972(ra) # 80000d02 <copyinstr>
    800020d6:	00054e63          	bltz	a0,800020f2 <fetchstr+0x48>
  return strlen(buf);
    800020da:	8526                	mv	a0,s1
    800020dc:	ffffe097          	auipc	ra,0xffffe
    800020e0:	25c080e7          	jalr	604(ra) # 80000338 <strlen>
}
    800020e4:	70a2                	ld	ra,40(sp)
    800020e6:	7402                	ld	s0,32(sp)
    800020e8:	64e2                	ld	s1,24(sp)
    800020ea:	6942                	ld	s2,16(sp)
    800020ec:	69a2                	ld	s3,8(sp)
    800020ee:	6145                	add	sp,sp,48
    800020f0:	8082                	ret
    return -1;
    800020f2:	557d                	li	a0,-1
    800020f4:	bfc5                	j	800020e4 <fetchstr+0x3a>

00000000800020f6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020f6:	1101                	add	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	1000                	add	s0,sp,32
    80002100:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002102:	00000097          	auipc	ra,0x0
    80002106:	eee080e7          	jalr	-274(ra) # 80001ff0 <argraw>
    8000210a:	c088                	sw	a0,0(s1)
}
    8000210c:	60e2                	ld	ra,24(sp)
    8000210e:	6442                	ld	s0,16(sp)
    80002110:	64a2                	ld	s1,8(sp)
    80002112:	6105                	add	sp,sp,32
    80002114:	8082                	ret

0000000080002116 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002116:	1101                	add	sp,sp,-32
    80002118:	ec06                	sd	ra,24(sp)
    8000211a:	e822                	sd	s0,16(sp)
    8000211c:	e426                	sd	s1,8(sp)
    8000211e:	1000                	add	s0,sp,32
    80002120:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002122:	00000097          	auipc	ra,0x0
    80002126:	ece080e7          	jalr	-306(ra) # 80001ff0 <argraw>
    8000212a:	e088                	sd	a0,0(s1)
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	64a2                	ld	s1,8(sp)
    80002132:	6105                	add	sp,sp,32
    80002134:	8082                	ret

0000000080002136 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002136:	7179                	add	sp,sp,-48
    80002138:	f406                	sd	ra,40(sp)
    8000213a:	f022                	sd	s0,32(sp)
    8000213c:	ec26                	sd	s1,24(sp)
    8000213e:	e84a                	sd	s2,16(sp)
    80002140:	1800                	add	s0,sp,48
    80002142:	84ae                	mv	s1,a1
    80002144:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002146:	fd840593          	add	a1,s0,-40
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	fcc080e7          	jalr	-52(ra) # 80002116 <argaddr>
  return fetchstr(addr, buf, max);
    80002152:	864a                	mv	a2,s2
    80002154:	85a6                	mv	a1,s1
    80002156:	fd843503          	ld	a0,-40(s0)
    8000215a:	00000097          	auipc	ra,0x0
    8000215e:	f50080e7          	jalr	-176(ra) # 800020aa <fetchstr>
}
    80002162:	70a2                	ld	ra,40(sp)
    80002164:	7402                	ld	s0,32(sp)
    80002166:	64e2                	ld	s1,24(sp)
    80002168:	6942                	ld	s2,16(sp)
    8000216a:	6145                	add	sp,sp,48
    8000216c:	8082                	ret

000000008000216e <syscall>:
[SYS_sysinfo] sys_info,
};

void
syscall(void)
{
    8000216e:	1101                	add	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	e426                	sd	s1,8(sp)
    80002176:	e04a                	sd	s2,0(sp)
    80002178:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	dd6080e7          	jalr	-554(ra) # 80000f50 <myproc>
    80002182:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002184:	05853903          	ld	s2,88(a0)
    80002188:	0a893783          	ld	a5,168(s2)
    8000218c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002190:	37fd                	addw	a5,a5,-1
    80002192:	4759                	li	a4,22
    80002194:	00f76f63          	bltu	a4,a5,800021b2 <syscall+0x44>
    80002198:	00369713          	sll	a4,a3,0x3
    8000219c:	00006797          	auipc	a5,0x6
    800021a0:	61c78793          	add	a5,a5,1564 # 800087b8 <syscalls>
    800021a4:	97ba                	add	a5,a5,a4
    800021a6:	639c                	ld	a5,0(a5)
    800021a8:	c789                	beqz	a5,800021b2 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021aa:	9782                	jalr	a5
    800021ac:	06a93823          	sd	a0,112(s2)
    800021b0:	a839                	j	800021ce <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021b2:	15848613          	add	a2,s1,344
    800021b6:	588c                	lw	a1,48(s1)
    800021b8:	00006517          	auipc	a0,0x6
    800021bc:	1f050513          	add	a0,a0,496 # 800083a8 <etext+0x3a8>
    800021c0:	00004097          	auipc	ra,0x4
    800021c4:	cec080e7          	jalr	-788(ra) # 80005eac <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021c8:	6cbc                	ld	a5,88(s1)
    800021ca:	577d                	li	a4,-1
    800021cc:	fbb8                	sd	a4,112(a5)
  }
}
    800021ce:	60e2                	ld	ra,24(sp)
    800021d0:	6442                	ld	s0,16(sp)
    800021d2:	64a2                	ld	s1,8(sp)
    800021d4:	6902                	ld	s2,0(sp)
    800021d6:	6105                	add	sp,sp,32
    800021d8:	8082                	ret

00000000800021da <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021da:	1101                	add	sp,sp,-32
    800021dc:	ec06                	sd	ra,24(sp)
    800021de:	e822                	sd	s0,16(sp)
    800021e0:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800021e2:	fec40593          	add	a1,s0,-20
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	f0e080e7          	jalr	-242(ra) # 800020f6 <argint>
  exit(n);
    800021f0:	fec42503          	lw	a0,-20(s0)
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	53e080e7          	jalr	1342(ra) # 80001732 <exit>
  return 0;  // not reached
}
    800021fc:	4501                	li	a0,0
    800021fe:	60e2                	ld	ra,24(sp)
    80002200:	6442                	ld	s0,16(sp)
    80002202:	6105                	add	sp,sp,32
    80002204:	8082                	ret

0000000080002206 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002206:	1141                	add	sp,sp,-16
    80002208:	e406                	sd	ra,8(sp)
    8000220a:	e022                	sd	s0,0(sp)
    8000220c:	0800                	add	s0,sp,16
  return myproc()->pid;
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	d42080e7          	jalr	-702(ra) # 80000f50 <myproc>
}
    80002216:	5908                	lw	a0,48(a0)
    80002218:	60a2                	ld	ra,8(sp)
    8000221a:	6402                	ld	s0,0(sp)
    8000221c:	0141                	add	sp,sp,16
    8000221e:	8082                	ret

0000000080002220 <sys_fork>:

uint64
sys_fork(void)
{
    80002220:	1141                	add	sp,sp,-16
    80002222:	e406                	sd	ra,8(sp)
    80002224:	e022                	sd	s0,0(sp)
    80002226:	0800                	add	s0,sp,16
  return fork();
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	0e2080e7          	jalr	226(ra) # 8000130a <fork>
}
    80002230:	60a2                	ld	ra,8(sp)
    80002232:	6402                	ld	s0,0(sp)
    80002234:	0141                	add	sp,sp,16
    80002236:	8082                	ret

0000000080002238 <sys_wait>:

uint64
sys_wait(void)
{
    80002238:	1101                	add	sp,sp,-32
    8000223a:	ec06                	sd	ra,24(sp)
    8000223c:	e822                	sd	s0,16(sp)
    8000223e:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002240:	fe840593          	add	a1,s0,-24
    80002244:	4501                	li	a0,0
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	ed0080e7          	jalr	-304(ra) # 80002116 <argaddr>
  return wait(p);
    8000224e:	fe843503          	ld	a0,-24(s0)
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	686080e7          	jalr	1670(ra) # 800018d8 <wait>
}
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	6105                	add	sp,sp,32
    80002260:	8082                	ret

0000000080002262 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002262:	7179                	add	sp,sp,-48
    80002264:	f406                	sd	ra,40(sp)
    80002266:	f022                	sd	s0,32(sp)
    80002268:	ec26                	sd	s1,24(sp)
    8000226a:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000226c:	fdc40593          	add	a1,s0,-36
    80002270:	4501                	li	a0,0
    80002272:	00000097          	auipc	ra,0x0
    80002276:	e84080e7          	jalr	-380(ra) # 800020f6 <argint>
  addr = myproc()->sz;
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	cd6080e7          	jalr	-810(ra) # 80000f50 <myproc>
    80002282:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002284:	fdc42503          	lw	a0,-36(s0)
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	026080e7          	jalr	38(ra) # 800012ae <growproc>
    80002290:	00054863          	bltz	a0,800022a0 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002294:	8526                	mv	a0,s1
    80002296:	70a2                	ld	ra,40(sp)
    80002298:	7402                	ld	s0,32(sp)
    8000229a:	64e2                	ld	s1,24(sp)
    8000229c:	6145                	add	sp,sp,48
    8000229e:	8082                	ret
    return -1;
    800022a0:	54fd                	li	s1,-1
    800022a2:	bfcd                	j	80002294 <sys_sbrk+0x32>

00000000800022a4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022a4:	7139                	add	sp,sp,-64
    800022a6:	fc06                	sd	ra,56(sp)
    800022a8:	f822                	sd	s0,48(sp)
    800022aa:	f04a                	sd	s2,32(sp)
    800022ac:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800022ae:	fcc40593          	add	a1,s0,-52
    800022b2:	4501                	li	a0,0
    800022b4:	00000097          	auipc	ra,0x0
    800022b8:	e42080e7          	jalr	-446(ra) # 800020f6 <argint>
  if(n < 0)
    800022bc:	fcc42783          	lw	a5,-52(s0)
    800022c0:	0807c163          	bltz	a5,80002342 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800022c4:	0000c517          	auipc	a0,0xc
    800022c8:	49c50513          	add	a0,a0,1180 # 8000e760 <tickslock>
    800022cc:	00004097          	auipc	ra,0x4
    800022d0:	110080e7          	jalr	272(ra) # 800063dc <acquire>
  ticks0 = ticks;
    800022d4:	00006917          	auipc	s2,0x6
    800022d8:	62492903          	lw	s2,1572(s2) # 800088f8 <ticks>
  while(ticks - ticks0 < n){
    800022dc:	fcc42783          	lw	a5,-52(s0)
    800022e0:	c3b9                	beqz	a5,80002326 <sys_sleep+0x82>
    800022e2:	f426                	sd	s1,40(sp)
    800022e4:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022e6:	0000c997          	auipc	s3,0xc
    800022ea:	47a98993          	add	s3,s3,1146 # 8000e760 <tickslock>
    800022ee:	00006497          	auipc	s1,0x6
    800022f2:	60a48493          	add	s1,s1,1546 # 800088f8 <ticks>
    if(killed(myproc())){
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	c5a080e7          	jalr	-934(ra) # 80000f50 <myproc>
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	5a8080e7          	jalr	1448(ra) # 800018a6 <killed>
    80002306:	e129                	bnez	a0,80002348 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002308:	85ce                	mv	a1,s3
    8000230a:	8526                	mv	a0,s1
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	2f2080e7          	jalr	754(ra) # 800015fe <sleep>
  while(ticks - ticks0 < n){
    80002314:	409c                	lw	a5,0(s1)
    80002316:	412787bb          	subw	a5,a5,s2
    8000231a:	fcc42703          	lw	a4,-52(s0)
    8000231e:	fce7ece3          	bltu	a5,a4,800022f6 <sys_sleep+0x52>
    80002322:	74a2                	ld	s1,40(sp)
    80002324:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002326:	0000c517          	auipc	a0,0xc
    8000232a:	43a50513          	add	a0,a0,1082 # 8000e760 <tickslock>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	162080e7          	jalr	354(ra) # 80006490 <release>
  return 0;
    80002336:	4501                	li	a0,0
}
    80002338:	70e2                	ld	ra,56(sp)
    8000233a:	7442                	ld	s0,48(sp)
    8000233c:	7902                	ld	s2,32(sp)
    8000233e:	6121                	add	sp,sp,64
    80002340:	8082                	ret
    n = 0;
    80002342:	fc042623          	sw	zero,-52(s0)
    80002346:	bfbd                	j	800022c4 <sys_sleep+0x20>
      release(&tickslock);
    80002348:	0000c517          	auipc	a0,0xc
    8000234c:	41850513          	add	a0,a0,1048 # 8000e760 <tickslock>
    80002350:	00004097          	auipc	ra,0x4
    80002354:	140080e7          	jalr	320(ra) # 80006490 <release>
      return -1;
    80002358:	557d                	li	a0,-1
    8000235a:	74a2                	ld	s1,40(sp)
    8000235c:	69e2                	ld	s3,24(sp)
    8000235e:	bfe9                	j	80002338 <sys_sleep+0x94>

0000000080002360 <sys_kill>:

uint64
sys_kill(void)
{
    80002360:	1101                	add	sp,sp,-32
    80002362:	ec06                	sd	ra,24(sp)
    80002364:	e822                	sd	s0,16(sp)
    80002366:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002368:	fec40593          	add	a1,s0,-20
    8000236c:	4501                	li	a0,0
    8000236e:	00000097          	auipc	ra,0x0
    80002372:	d88080e7          	jalr	-632(ra) # 800020f6 <argint>
  return kill(pid);
    80002376:	fec42503          	lw	a0,-20(s0)
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	48e080e7          	jalr	1166(ra) # 80001808 <kill>
}
    80002382:	60e2                	ld	ra,24(sp)
    80002384:	6442                	ld	s0,16(sp)
    80002386:	6105                	add	sp,sp,32
    80002388:	8082                	ret

000000008000238a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000238a:	1101                	add	sp,sp,-32
    8000238c:	ec06                	sd	ra,24(sp)
    8000238e:	e822                	sd	s0,16(sp)
    80002390:	e426                	sd	s1,8(sp)
    80002392:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002394:	0000c517          	auipc	a0,0xc
    80002398:	3cc50513          	add	a0,a0,972 # 8000e760 <tickslock>
    8000239c:	00004097          	auipc	ra,0x4
    800023a0:	040080e7          	jalr	64(ra) # 800063dc <acquire>
  xticks = ticks;
    800023a4:	00006497          	auipc	s1,0x6
    800023a8:	5544a483          	lw	s1,1364(s1) # 800088f8 <ticks>
  release(&tickslock);
    800023ac:	0000c517          	auipc	a0,0xc
    800023b0:	3b450513          	add	a0,a0,948 # 8000e760 <tickslock>
    800023b4:	00004097          	auipc	ra,0x4
    800023b8:	0dc080e7          	jalr	220(ra) # 80006490 <release>
  return xticks;
}
    800023bc:	02049513          	sll	a0,s1,0x20
    800023c0:	9101                	srl	a0,a0,0x20
    800023c2:	60e2                	ld	ra,24(sp)
    800023c4:	6442                	ld	s0,16(sp)
    800023c6:	64a2                	ld	s1,8(sp)
    800023c8:	6105                	add	sp,sp,32
    800023ca:	8082                	ret

00000000800023cc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023cc:	7179                	add	sp,sp,-48
    800023ce:	f406                	sd	ra,40(sp)
    800023d0:	f022                	sd	s0,32(sp)
    800023d2:	ec26                	sd	s1,24(sp)
    800023d4:	e84a                	sd	s2,16(sp)
    800023d6:	e44e                	sd	s3,8(sp)
    800023d8:	e052                	sd	s4,0(sp)
    800023da:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023dc:	00006597          	auipc	a1,0x6
    800023e0:	fec58593          	add	a1,a1,-20 # 800083c8 <etext+0x3c8>
    800023e4:	0000c517          	auipc	a0,0xc
    800023e8:	39450513          	add	a0,a0,916 # 8000e778 <bcache>
    800023ec:	00004097          	auipc	ra,0x4
    800023f0:	f60080e7          	jalr	-160(ra) # 8000634c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023f4:	00014797          	auipc	a5,0x14
    800023f8:	38478793          	add	a5,a5,900 # 80016778 <bcache+0x8000>
    800023fc:	00014717          	auipc	a4,0x14
    80002400:	5e470713          	add	a4,a4,1508 # 800169e0 <bcache+0x8268>
    80002404:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002408:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000240c:	0000c497          	auipc	s1,0xc
    80002410:	38448493          	add	s1,s1,900 # 8000e790 <bcache+0x18>
    b->next = bcache.head.next;
    80002414:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002416:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002418:	00006a17          	auipc	s4,0x6
    8000241c:	fb8a0a13          	add	s4,s4,-72 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    80002420:	2b893783          	ld	a5,696(s2)
    80002424:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002426:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000242a:	85d2                	mv	a1,s4
    8000242c:	01048513          	add	a0,s1,16
    80002430:	00001097          	auipc	ra,0x1
    80002434:	4e8080e7          	jalr	1256(ra) # 80003918 <initsleeplock>
    bcache.head.next->prev = b;
    80002438:	2b893783          	ld	a5,696(s2)
    8000243c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000243e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002442:	45848493          	add	s1,s1,1112
    80002446:	fd349de3          	bne	s1,s3,80002420 <binit+0x54>
  }
}
    8000244a:	70a2                	ld	ra,40(sp)
    8000244c:	7402                	ld	s0,32(sp)
    8000244e:	64e2                	ld	s1,24(sp)
    80002450:	6942                	ld	s2,16(sp)
    80002452:	69a2                	ld	s3,8(sp)
    80002454:	6a02                	ld	s4,0(sp)
    80002456:	6145                	add	sp,sp,48
    80002458:	8082                	ret

000000008000245a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000245a:	7179                	add	sp,sp,-48
    8000245c:	f406                	sd	ra,40(sp)
    8000245e:	f022                	sd	s0,32(sp)
    80002460:	ec26                	sd	s1,24(sp)
    80002462:	e84a                	sd	s2,16(sp)
    80002464:	e44e                	sd	s3,8(sp)
    80002466:	1800                	add	s0,sp,48
    80002468:	892a                	mv	s2,a0
    8000246a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000246c:	0000c517          	auipc	a0,0xc
    80002470:	30c50513          	add	a0,a0,780 # 8000e778 <bcache>
    80002474:	00004097          	auipc	ra,0x4
    80002478:	f68080e7          	jalr	-152(ra) # 800063dc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000247c:	00014497          	auipc	s1,0x14
    80002480:	5b44b483          	ld	s1,1460(s1) # 80016a30 <bcache+0x82b8>
    80002484:	00014797          	auipc	a5,0x14
    80002488:	55c78793          	add	a5,a5,1372 # 800169e0 <bcache+0x8268>
    8000248c:	02f48f63          	beq	s1,a5,800024ca <bread+0x70>
    80002490:	873e                	mv	a4,a5
    80002492:	a021                	j	8000249a <bread+0x40>
    80002494:	68a4                	ld	s1,80(s1)
    80002496:	02e48a63          	beq	s1,a4,800024ca <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000249a:	449c                	lw	a5,8(s1)
    8000249c:	ff279ce3          	bne	a5,s2,80002494 <bread+0x3a>
    800024a0:	44dc                	lw	a5,12(s1)
    800024a2:	ff3799e3          	bne	a5,s3,80002494 <bread+0x3a>
      b->refcnt++;
    800024a6:	40bc                	lw	a5,64(s1)
    800024a8:	2785                	addw	a5,a5,1
    800024aa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024ac:	0000c517          	auipc	a0,0xc
    800024b0:	2cc50513          	add	a0,a0,716 # 8000e778 <bcache>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	fdc080e7          	jalr	-36(ra) # 80006490 <release>
      acquiresleep(&b->lock);
    800024bc:	01048513          	add	a0,s1,16
    800024c0:	00001097          	auipc	ra,0x1
    800024c4:	492080e7          	jalr	1170(ra) # 80003952 <acquiresleep>
      return b;
    800024c8:	a8b9                	j	80002526 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024ca:	00014497          	auipc	s1,0x14
    800024ce:	55e4b483          	ld	s1,1374(s1) # 80016a28 <bcache+0x82b0>
    800024d2:	00014797          	auipc	a5,0x14
    800024d6:	50e78793          	add	a5,a5,1294 # 800169e0 <bcache+0x8268>
    800024da:	00f48863          	beq	s1,a5,800024ea <bread+0x90>
    800024de:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024e0:	40bc                	lw	a5,64(s1)
    800024e2:	cf81                	beqz	a5,800024fa <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024e4:	64a4                	ld	s1,72(s1)
    800024e6:	fee49de3          	bne	s1,a4,800024e0 <bread+0x86>
  panic("bget: no buffers");
    800024ea:	00006517          	auipc	a0,0x6
    800024ee:	eee50513          	add	a0,a0,-274 # 800083d8 <etext+0x3d8>
    800024f2:	00004097          	auipc	ra,0x4
    800024f6:	970080e7          	jalr	-1680(ra) # 80005e62 <panic>
      b->dev = dev;
    800024fa:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024fe:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002502:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002506:	4785                	li	a5,1
    80002508:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000250a:	0000c517          	auipc	a0,0xc
    8000250e:	26e50513          	add	a0,a0,622 # 8000e778 <bcache>
    80002512:	00004097          	auipc	ra,0x4
    80002516:	f7e080e7          	jalr	-130(ra) # 80006490 <release>
      acquiresleep(&b->lock);
    8000251a:	01048513          	add	a0,s1,16
    8000251e:	00001097          	auipc	ra,0x1
    80002522:	434080e7          	jalr	1076(ra) # 80003952 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002526:	409c                	lw	a5,0(s1)
    80002528:	cb89                	beqz	a5,8000253a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000252a:	8526                	mv	a0,s1
    8000252c:	70a2                	ld	ra,40(sp)
    8000252e:	7402                	ld	s0,32(sp)
    80002530:	64e2                	ld	s1,24(sp)
    80002532:	6942                	ld	s2,16(sp)
    80002534:	69a2                	ld	s3,8(sp)
    80002536:	6145                	add	sp,sp,48
    80002538:	8082                	ret
    virtio_disk_rw(b, 0);
    8000253a:	4581                	li	a1,0
    8000253c:	8526                	mv	a0,s1
    8000253e:	00003097          	auipc	ra,0x3
    80002542:	0fa080e7          	jalr	250(ra) # 80005638 <virtio_disk_rw>
    b->valid = 1;
    80002546:	4785                	li	a5,1
    80002548:	c09c                	sw	a5,0(s1)
  return b;
    8000254a:	b7c5                	j	8000252a <bread+0xd0>

000000008000254c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000254c:	1101                	add	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	1000                	add	s0,sp,32
    80002556:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002558:	0541                	add	a0,a0,16
    8000255a:	00001097          	auipc	ra,0x1
    8000255e:	492080e7          	jalr	1170(ra) # 800039ec <holdingsleep>
    80002562:	cd01                	beqz	a0,8000257a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002564:	4585                	li	a1,1
    80002566:	8526                	mv	a0,s1
    80002568:	00003097          	auipc	ra,0x3
    8000256c:	0d0080e7          	jalr	208(ra) # 80005638 <virtio_disk_rw>
}
    80002570:	60e2                	ld	ra,24(sp)
    80002572:	6442                	ld	s0,16(sp)
    80002574:	64a2                	ld	s1,8(sp)
    80002576:	6105                	add	sp,sp,32
    80002578:	8082                	ret
    panic("bwrite");
    8000257a:	00006517          	auipc	a0,0x6
    8000257e:	e7650513          	add	a0,a0,-394 # 800083f0 <etext+0x3f0>
    80002582:	00004097          	auipc	ra,0x4
    80002586:	8e0080e7          	jalr	-1824(ra) # 80005e62 <panic>

000000008000258a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000258a:	1101                	add	sp,sp,-32
    8000258c:	ec06                	sd	ra,24(sp)
    8000258e:	e822                	sd	s0,16(sp)
    80002590:	e426                	sd	s1,8(sp)
    80002592:	e04a                	sd	s2,0(sp)
    80002594:	1000                	add	s0,sp,32
    80002596:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002598:	01050913          	add	s2,a0,16
    8000259c:	854a                	mv	a0,s2
    8000259e:	00001097          	auipc	ra,0x1
    800025a2:	44e080e7          	jalr	1102(ra) # 800039ec <holdingsleep>
    800025a6:	c925                	beqz	a0,80002616 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800025a8:	854a                	mv	a0,s2
    800025aa:	00001097          	auipc	ra,0x1
    800025ae:	3fe080e7          	jalr	1022(ra) # 800039a8 <releasesleep>

  acquire(&bcache.lock);
    800025b2:	0000c517          	auipc	a0,0xc
    800025b6:	1c650513          	add	a0,a0,454 # 8000e778 <bcache>
    800025ba:	00004097          	auipc	ra,0x4
    800025be:	e22080e7          	jalr	-478(ra) # 800063dc <acquire>
  b->refcnt--;
    800025c2:	40bc                	lw	a5,64(s1)
    800025c4:	37fd                	addw	a5,a5,-1
    800025c6:	0007871b          	sext.w	a4,a5
    800025ca:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025cc:	e71d                	bnez	a4,800025fa <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025ce:	68b8                	ld	a4,80(s1)
    800025d0:	64bc                	ld	a5,72(s1)
    800025d2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800025d4:	68b8                	ld	a4,80(s1)
    800025d6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025d8:	00014797          	auipc	a5,0x14
    800025dc:	1a078793          	add	a5,a5,416 # 80016778 <bcache+0x8000>
    800025e0:	2b87b703          	ld	a4,696(a5)
    800025e4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025e6:	00014717          	auipc	a4,0x14
    800025ea:	3fa70713          	add	a4,a4,1018 # 800169e0 <bcache+0x8268>
    800025ee:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025f0:	2b87b703          	ld	a4,696(a5)
    800025f4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025f6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025fa:	0000c517          	auipc	a0,0xc
    800025fe:	17e50513          	add	a0,a0,382 # 8000e778 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	e8e080e7          	jalr	-370(ra) # 80006490 <release>
}
    8000260a:	60e2                	ld	ra,24(sp)
    8000260c:	6442                	ld	s0,16(sp)
    8000260e:	64a2                	ld	s1,8(sp)
    80002610:	6902                	ld	s2,0(sp)
    80002612:	6105                	add	sp,sp,32
    80002614:	8082                	ret
    panic("brelse");
    80002616:	00006517          	auipc	a0,0x6
    8000261a:	de250513          	add	a0,a0,-542 # 800083f8 <etext+0x3f8>
    8000261e:	00004097          	auipc	ra,0x4
    80002622:	844080e7          	jalr	-1980(ra) # 80005e62 <panic>

0000000080002626 <bpin>:

void
bpin(struct buf *b) {
    80002626:	1101                	add	sp,sp,-32
    80002628:	ec06                	sd	ra,24(sp)
    8000262a:	e822                	sd	s0,16(sp)
    8000262c:	e426                	sd	s1,8(sp)
    8000262e:	1000                	add	s0,sp,32
    80002630:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002632:	0000c517          	auipc	a0,0xc
    80002636:	14650513          	add	a0,a0,326 # 8000e778 <bcache>
    8000263a:	00004097          	auipc	ra,0x4
    8000263e:	da2080e7          	jalr	-606(ra) # 800063dc <acquire>
  b->refcnt++;
    80002642:	40bc                	lw	a5,64(s1)
    80002644:	2785                	addw	a5,a5,1
    80002646:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002648:	0000c517          	auipc	a0,0xc
    8000264c:	13050513          	add	a0,a0,304 # 8000e778 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	e40080e7          	jalr	-448(ra) # 80006490 <release>
}
    80002658:	60e2                	ld	ra,24(sp)
    8000265a:	6442                	ld	s0,16(sp)
    8000265c:	64a2                	ld	s1,8(sp)
    8000265e:	6105                	add	sp,sp,32
    80002660:	8082                	ret

0000000080002662 <bunpin>:

void
bunpin(struct buf *b) {
    80002662:	1101                	add	sp,sp,-32
    80002664:	ec06                	sd	ra,24(sp)
    80002666:	e822                	sd	s0,16(sp)
    80002668:	e426                	sd	s1,8(sp)
    8000266a:	1000                	add	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000266e:	0000c517          	auipc	a0,0xc
    80002672:	10a50513          	add	a0,a0,266 # 8000e778 <bcache>
    80002676:	00004097          	auipc	ra,0x4
    8000267a:	d66080e7          	jalr	-666(ra) # 800063dc <acquire>
  b->refcnt--;
    8000267e:	40bc                	lw	a5,64(s1)
    80002680:	37fd                	addw	a5,a5,-1
    80002682:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002684:	0000c517          	auipc	a0,0xc
    80002688:	0f450513          	add	a0,a0,244 # 8000e778 <bcache>
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	e04080e7          	jalr	-508(ra) # 80006490 <release>
}
    80002694:	60e2                	ld	ra,24(sp)
    80002696:	6442                	ld	s0,16(sp)
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	6105                	add	sp,sp,32
    8000269c:	8082                	ret

000000008000269e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000269e:	1101                	add	sp,sp,-32
    800026a0:	ec06                	sd	ra,24(sp)
    800026a2:	e822                	sd	s0,16(sp)
    800026a4:	e426                	sd	s1,8(sp)
    800026a6:	e04a                	sd	s2,0(sp)
    800026a8:	1000                	add	s0,sp,32
    800026aa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026ac:	00d5d59b          	srlw	a1,a1,0xd
    800026b0:	00014797          	auipc	a5,0x14
    800026b4:	7a47a783          	lw	a5,1956(a5) # 80016e54 <sb+0x1c>
    800026b8:	9dbd                	addw	a1,a1,a5
    800026ba:	00000097          	auipc	ra,0x0
    800026be:	da0080e7          	jalr	-608(ra) # 8000245a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026c2:	0074f713          	and	a4,s1,7
    800026c6:	4785                	li	a5,1
    800026c8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026cc:	14ce                	sll	s1,s1,0x33
    800026ce:	90d9                	srl	s1,s1,0x36
    800026d0:	00950733          	add	a4,a0,s1
    800026d4:	05874703          	lbu	a4,88(a4)
    800026d8:	00e7f6b3          	and	a3,a5,a4
    800026dc:	c69d                	beqz	a3,8000270a <bfree+0x6c>
    800026de:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026e0:	94aa                	add	s1,s1,a0
    800026e2:	fff7c793          	not	a5,a5
    800026e6:	8f7d                	and	a4,a4,a5
    800026e8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026ec:	00001097          	auipc	ra,0x1
    800026f0:	148080e7          	jalr	328(ra) # 80003834 <log_write>
  brelse(bp);
    800026f4:	854a                	mv	a0,s2
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	e94080e7          	jalr	-364(ra) # 8000258a <brelse>
}
    800026fe:	60e2                	ld	ra,24(sp)
    80002700:	6442                	ld	s0,16(sp)
    80002702:	64a2                	ld	s1,8(sp)
    80002704:	6902                	ld	s2,0(sp)
    80002706:	6105                	add	sp,sp,32
    80002708:	8082                	ret
    panic("freeing free block");
    8000270a:	00006517          	auipc	a0,0x6
    8000270e:	cf650513          	add	a0,a0,-778 # 80008400 <etext+0x400>
    80002712:	00003097          	auipc	ra,0x3
    80002716:	750080e7          	jalr	1872(ra) # 80005e62 <panic>

000000008000271a <balloc>:
{
    8000271a:	711d                	add	sp,sp,-96
    8000271c:	ec86                	sd	ra,88(sp)
    8000271e:	e8a2                	sd	s0,80(sp)
    80002720:	e4a6                	sd	s1,72(sp)
    80002722:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002724:	00014797          	auipc	a5,0x14
    80002728:	7187a783          	lw	a5,1816(a5) # 80016e3c <sb+0x4>
    8000272c:	10078f63          	beqz	a5,8000284a <balloc+0x130>
    80002730:	e0ca                	sd	s2,64(sp)
    80002732:	fc4e                	sd	s3,56(sp)
    80002734:	f852                	sd	s4,48(sp)
    80002736:	f456                	sd	s5,40(sp)
    80002738:	f05a                	sd	s6,32(sp)
    8000273a:	ec5e                	sd	s7,24(sp)
    8000273c:	e862                	sd	s8,16(sp)
    8000273e:	e466                	sd	s9,8(sp)
    80002740:	8baa                	mv	s7,a0
    80002742:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002744:	00014b17          	auipc	s6,0x14
    80002748:	6f4b0b13          	add	s6,s6,1780 # 80016e38 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000274c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000274e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002750:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002752:	6c89                	lui	s9,0x2
    80002754:	a061                	j	800027dc <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002756:	97ca                	add	a5,a5,s2
    80002758:	8e55                	or	a2,a2,a3
    8000275a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000275e:	854a                	mv	a0,s2
    80002760:	00001097          	auipc	ra,0x1
    80002764:	0d4080e7          	jalr	212(ra) # 80003834 <log_write>
        brelse(bp);
    80002768:	854a                	mv	a0,s2
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	e20080e7          	jalr	-480(ra) # 8000258a <brelse>
  bp = bread(dev, bno);
    80002772:	85a6                	mv	a1,s1
    80002774:	855e                	mv	a0,s7
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	ce4080e7          	jalr	-796(ra) # 8000245a <bread>
    8000277e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002780:	40000613          	li	a2,1024
    80002784:	4581                	li	a1,0
    80002786:	05850513          	add	a0,a0,88
    8000278a:	ffffe097          	auipc	ra,0xffffe
    8000278e:	a3a080e7          	jalr	-1478(ra) # 800001c4 <memset>
  log_write(bp);
    80002792:	854a                	mv	a0,s2
    80002794:	00001097          	auipc	ra,0x1
    80002798:	0a0080e7          	jalr	160(ra) # 80003834 <log_write>
  brelse(bp);
    8000279c:	854a                	mv	a0,s2
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	dec080e7          	jalr	-532(ra) # 8000258a <brelse>
}
    800027a6:	6906                	ld	s2,64(sp)
    800027a8:	79e2                	ld	s3,56(sp)
    800027aa:	7a42                	ld	s4,48(sp)
    800027ac:	7aa2                	ld	s5,40(sp)
    800027ae:	7b02                	ld	s6,32(sp)
    800027b0:	6be2                	ld	s7,24(sp)
    800027b2:	6c42                	ld	s8,16(sp)
    800027b4:	6ca2                	ld	s9,8(sp)
}
    800027b6:	8526                	mv	a0,s1
    800027b8:	60e6                	ld	ra,88(sp)
    800027ba:	6446                	ld	s0,80(sp)
    800027bc:	64a6                	ld	s1,72(sp)
    800027be:	6125                	add	sp,sp,96
    800027c0:	8082                	ret
    brelse(bp);
    800027c2:	854a                	mv	a0,s2
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	dc6080e7          	jalr	-570(ra) # 8000258a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027cc:	015c87bb          	addw	a5,s9,s5
    800027d0:	00078a9b          	sext.w	s5,a5
    800027d4:	004b2703          	lw	a4,4(s6)
    800027d8:	06eaf163          	bgeu	s5,a4,8000283a <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800027dc:	41fad79b          	sraw	a5,s5,0x1f
    800027e0:	0137d79b          	srlw	a5,a5,0x13
    800027e4:	015787bb          	addw	a5,a5,s5
    800027e8:	40d7d79b          	sraw	a5,a5,0xd
    800027ec:	01cb2583          	lw	a1,28(s6)
    800027f0:	9dbd                	addw	a1,a1,a5
    800027f2:	855e                	mv	a0,s7
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	c66080e7          	jalr	-922(ra) # 8000245a <bread>
    800027fc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fe:	004b2503          	lw	a0,4(s6)
    80002802:	000a849b          	sext.w	s1,s5
    80002806:	8762                	mv	a4,s8
    80002808:	faa4fde3          	bgeu	s1,a0,800027c2 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000280c:	00777693          	and	a3,a4,7
    80002810:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002814:	41f7579b          	sraw	a5,a4,0x1f
    80002818:	01d7d79b          	srlw	a5,a5,0x1d
    8000281c:	9fb9                	addw	a5,a5,a4
    8000281e:	4037d79b          	sraw	a5,a5,0x3
    80002822:	00f90633          	add	a2,s2,a5
    80002826:	05864603          	lbu	a2,88(a2)
    8000282a:	00c6f5b3          	and	a1,a3,a2
    8000282e:	d585                	beqz	a1,80002756 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002830:	2705                	addw	a4,a4,1
    80002832:	2485                	addw	s1,s1,1
    80002834:	fd471ae3          	bne	a4,s4,80002808 <balloc+0xee>
    80002838:	b769                	j	800027c2 <balloc+0xa8>
    8000283a:	6906                	ld	s2,64(sp)
    8000283c:	79e2                	ld	s3,56(sp)
    8000283e:	7a42                	ld	s4,48(sp)
    80002840:	7aa2                	ld	s5,40(sp)
    80002842:	7b02                	ld	s6,32(sp)
    80002844:	6be2                	ld	s7,24(sp)
    80002846:	6c42                	ld	s8,16(sp)
    80002848:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000284a:	00006517          	auipc	a0,0x6
    8000284e:	bce50513          	add	a0,a0,-1074 # 80008418 <etext+0x418>
    80002852:	00003097          	auipc	ra,0x3
    80002856:	65a080e7          	jalr	1626(ra) # 80005eac <printf>
  return 0;
    8000285a:	4481                	li	s1,0
    8000285c:	bfa9                	j	800027b6 <balloc+0x9c>

000000008000285e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000285e:	7179                	add	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	1800                	add	s0,sp,48
    8000286c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000286e:	47ad                	li	a5,11
    80002870:	02b7e863          	bltu	a5,a1,800028a0 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002874:	02059793          	sll	a5,a1,0x20
    80002878:	01e7d593          	srl	a1,a5,0x1e
    8000287c:	00b504b3          	add	s1,a0,a1
    80002880:	0504a903          	lw	s2,80(s1)
    80002884:	08091263          	bnez	s2,80002908 <bmap+0xaa>
      addr = balloc(ip->dev);
    80002888:	4108                	lw	a0,0(a0)
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	e90080e7          	jalr	-368(ra) # 8000271a <balloc>
    80002892:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002896:	06090963          	beqz	s2,80002908 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    8000289a:	0524a823          	sw	s2,80(s1)
    8000289e:	a0ad                	j	80002908 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028a0:	ff45849b          	addw	s1,a1,-12
    800028a4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028a8:	0ff00793          	li	a5,255
    800028ac:	08e7e863          	bltu	a5,a4,8000293c <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028b0:	08052903          	lw	s2,128(a0)
    800028b4:	00091f63          	bnez	s2,800028d2 <bmap+0x74>
      addr = balloc(ip->dev);
    800028b8:	4108                	lw	a0,0(a0)
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	e60080e7          	jalr	-416(ra) # 8000271a <balloc>
    800028c2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028c6:	04090163          	beqz	s2,80002908 <bmap+0xaa>
    800028ca:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028cc:	0929a023          	sw	s2,128(s3)
    800028d0:	a011                	j	800028d4 <bmap+0x76>
    800028d2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800028d4:	85ca                	mv	a1,s2
    800028d6:	0009a503          	lw	a0,0(s3)
    800028da:	00000097          	auipc	ra,0x0
    800028de:	b80080e7          	jalr	-1152(ra) # 8000245a <bread>
    800028e2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028e4:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800028e8:	02049713          	sll	a4,s1,0x20
    800028ec:	01e75593          	srl	a1,a4,0x1e
    800028f0:	00b784b3          	add	s1,a5,a1
    800028f4:	0004a903          	lw	s2,0(s1)
    800028f8:	02090063          	beqz	s2,80002918 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028fc:	8552                	mv	a0,s4
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	c8c080e7          	jalr	-884(ra) # 8000258a <brelse>
    return addr;
    80002906:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002908:	854a                	mv	a0,s2
    8000290a:	70a2                	ld	ra,40(sp)
    8000290c:	7402                	ld	s0,32(sp)
    8000290e:	64e2                	ld	s1,24(sp)
    80002910:	6942                	ld	s2,16(sp)
    80002912:	69a2                	ld	s3,8(sp)
    80002914:	6145                	add	sp,sp,48
    80002916:	8082                	ret
      addr = balloc(ip->dev);
    80002918:	0009a503          	lw	a0,0(s3)
    8000291c:	00000097          	auipc	ra,0x0
    80002920:	dfe080e7          	jalr	-514(ra) # 8000271a <balloc>
    80002924:	0005091b          	sext.w	s2,a0
      if(addr){
    80002928:	fc090ae3          	beqz	s2,800028fc <bmap+0x9e>
        a[bn] = addr;
    8000292c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002930:	8552                	mv	a0,s4
    80002932:	00001097          	auipc	ra,0x1
    80002936:	f02080e7          	jalr	-254(ra) # 80003834 <log_write>
    8000293a:	b7c9                	j	800028fc <bmap+0x9e>
    8000293c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000293e:	00006517          	auipc	a0,0x6
    80002942:	af250513          	add	a0,a0,-1294 # 80008430 <etext+0x430>
    80002946:	00003097          	auipc	ra,0x3
    8000294a:	51c080e7          	jalr	1308(ra) # 80005e62 <panic>

000000008000294e <iget>:
{
    8000294e:	7179                	add	sp,sp,-48
    80002950:	f406                	sd	ra,40(sp)
    80002952:	f022                	sd	s0,32(sp)
    80002954:	ec26                	sd	s1,24(sp)
    80002956:	e84a                	sd	s2,16(sp)
    80002958:	e44e                	sd	s3,8(sp)
    8000295a:	e052                	sd	s4,0(sp)
    8000295c:	1800                	add	s0,sp,48
    8000295e:	89aa                	mv	s3,a0
    80002960:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002962:	00014517          	auipc	a0,0x14
    80002966:	4f650513          	add	a0,a0,1270 # 80016e58 <itable>
    8000296a:	00004097          	auipc	ra,0x4
    8000296e:	a72080e7          	jalr	-1422(ra) # 800063dc <acquire>
  empty = 0;
    80002972:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002974:	00014497          	auipc	s1,0x14
    80002978:	4fc48493          	add	s1,s1,1276 # 80016e70 <itable+0x18>
    8000297c:	00016697          	auipc	a3,0x16
    80002980:	f8468693          	add	a3,a3,-124 # 80018900 <log>
    80002984:	a039                	j	80002992 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002986:	02090b63          	beqz	s2,800029bc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000298a:	08848493          	add	s1,s1,136
    8000298e:	02d48a63          	beq	s1,a3,800029c2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002992:	449c                	lw	a5,8(s1)
    80002994:	fef059e3          	blez	a5,80002986 <iget+0x38>
    80002998:	4098                	lw	a4,0(s1)
    8000299a:	ff3716e3          	bne	a4,s3,80002986 <iget+0x38>
    8000299e:	40d8                	lw	a4,4(s1)
    800029a0:	ff4713e3          	bne	a4,s4,80002986 <iget+0x38>
      ip->ref++;
    800029a4:	2785                	addw	a5,a5,1
    800029a6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029a8:	00014517          	auipc	a0,0x14
    800029ac:	4b050513          	add	a0,a0,1200 # 80016e58 <itable>
    800029b0:	00004097          	auipc	ra,0x4
    800029b4:	ae0080e7          	jalr	-1312(ra) # 80006490 <release>
      return ip;
    800029b8:	8926                	mv	s2,s1
    800029ba:	a03d                	j	800029e8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029bc:	f7f9                	bnez	a5,8000298a <iget+0x3c>
      empty = ip;
    800029be:	8926                	mv	s2,s1
    800029c0:	b7e9                	j	8000298a <iget+0x3c>
  if(empty == 0)
    800029c2:	02090c63          	beqz	s2,800029fa <iget+0xac>
  ip->dev = dev;
    800029c6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029ca:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029ce:	4785                	li	a5,1
    800029d0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029d4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029d8:	00014517          	auipc	a0,0x14
    800029dc:	48050513          	add	a0,a0,1152 # 80016e58 <itable>
    800029e0:	00004097          	auipc	ra,0x4
    800029e4:	ab0080e7          	jalr	-1360(ra) # 80006490 <release>
}
    800029e8:	854a                	mv	a0,s2
    800029ea:	70a2                	ld	ra,40(sp)
    800029ec:	7402                	ld	s0,32(sp)
    800029ee:	64e2                	ld	s1,24(sp)
    800029f0:	6942                	ld	s2,16(sp)
    800029f2:	69a2                	ld	s3,8(sp)
    800029f4:	6a02                	ld	s4,0(sp)
    800029f6:	6145                	add	sp,sp,48
    800029f8:	8082                	ret
    panic("iget: no inodes");
    800029fa:	00006517          	auipc	a0,0x6
    800029fe:	a4e50513          	add	a0,a0,-1458 # 80008448 <etext+0x448>
    80002a02:	00003097          	auipc	ra,0x3
    80002a06:	460080e7          	jalr	1120(ra) # 80005e62 <panic>

0000000080002a0a <fsinit>:
fsinit(int dev) {
    80002a0a:	7179                	add	sp,sp,-48
    80002a0c:	f406                	sd	ra,40(sp)
    80002a0e:	f022                	sd	s0,32(sp)
    80002a10:	ec26                	sd	s1,24(sp)
    80002a12:	e84a                	sd	s2,16(sp)
    80002a14:	e44e                	sd	s3,8(sp)
    80002a16:	1800                	add	s0,sp,48
    80002a18:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a1a:	4585                	li	a1,1
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	a3e080e7          	jalr	-1474(ra) # 8000245a <bread>
    80002a24:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a26:	00014997          	auipc	s3,0x14
    80002a2a:	41298993          	add	s3,s3,1042 # 80016e38 <sb>
    80002a2e:	02000613          	li	a2,32
    80002a32:	05850593          	add	a1,a0,88
    80002a36:	854e                	mv	a0,s3
    80002a38:	ffffd097          	auipc	ra,0xffffd
    80002a3c:	7e8080e7          	jalr	2024(ra) # 80000220 <memmove>
  brelse(bp);
    80002a40:	8526                	mv	a0,s1
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	b48080e7          	jalr	-1208(ra) # 8000258a <brelse>
  if(sb.magic != FSMAGIC)
    80002a4a:	0009a703          	lw	a4,0(s3)
    80002a4e:	102037b7          	lui	a5,0x10203
    80002a52:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a56:	02f71263          	bne	a4,a5,80002a7a <fsinit+0x70>
  initlog(dev, &sb);
    80002a5a:	00014597          	auipc	a1,0x14
    80002a5e:	3de58593          	add	a1,a1,990 # 80016e38 <sb>
    80002a62:	854a                	mv	a0,s2
    80002a64:	00001097          	auipc	ra,0x1
    80002a68:	b60080e7          	jalr	-1184(ra) # 800035c4 <initlog>
}
    80002a6c:	70a2                	ld	ra,40(sp)
    80002a6e:	7402                	ld	s0,32(sp)
    80002a70:	64e2                	ld	s1,24(sp)
    80002a72:	6942                	ld	s2,16(sp)
    80002a74:	69a2                	ld	s3,8(sp)
    80002a76:	6145                	add	sp,sp,48
    80002a78:	8082                	ret
    panic("invalid file system");
    80002a7a:	00006517          	auipc	a0,0x6
    80002a7e:	9de50513          	add	a0,a0,-1570 # 80008458 <etext+0x458>
    80002a82:	00003097          	auipc	ra,0x3
    80002a86:	3e0080e7          	jalr	992(ra) # 80005e62 <panic>

0000000080002a8a <iinit>:
{
    80002a8a:	7179                	add	sp,sp,-48
    80002a8c:	f406                	sd	ra,40(sp)
    80002a8e:	f022                	sd	s0,32(sp)
    80002a90:	ec26                	sd	s1,24(sp)
    80002a92:	e84a                	sd	s2,16(sp)
    80002a94:	e44e                	sd	s3,8(sp)
    80002a96:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a98:	00006597          	auipc	a1,0x6
    80002a9c:	9d858593          	add	a1,a1,-1576 # 80008470 <etext+0x470>
    80002aa0:	00014517          	auipc	a0,0x14
    80002aa4:	3b850513          	add	a0,a0,952 # 80016e58 <itable>
    80002aa8:	00004097          	auipc	ra,0x4
    80002aac:	8a4080e7          	jalr	-1884(ra) # 8000634c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ab0:	00014497          	auipc	s1,0x14
    80002ab4:	3d048493          	add	s1,s1,976 # 80016e80 <itable+0x28>
    80002ab8:	00016997          	auipc	s3,0x16
    80002abc:	e5898993          	add	s3,s3,-424 # 80018910 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ac0:	00006917          	auipc	s2,0x6
    80002ac4:	9b890913          	add	s2,s2,-1608 # 80008478 <etext+0x478>
    80002ac8:	85ca                	mv	a1,s2
    80002aca:	8526                	mv	a0,s1
    80002acc:	00001097          	auipc	ra,0x1
    80002ad0:	e4c080e7          	jalr	-436(ra) # 80003918 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ad4:	08848493          	add	s1,s1,136
    80002ad8:	ff3498e3          	bne	s1,s3,80002ac8 <iinit+0x3e>
}
    80002adc:	70a2                	ld	ra,40(sp)
    80002ade:	7402                	ld	s0,32(sp)
    80002ae0:	64e2                	ld	s1,24(sp)
    80002ae2:	6942                	ld	s2,16(sp)
    80002ae4:	69a2                	ld	s3,8(sp)
    80002ae6:	6145                	add	sp,sp,48
    80002ae8:	8082                	ret

0000000080002aea <ialloc>:
{
    80002aea:	7139                	add	sp,sp,-64
    80002aec:	fc06                	sd	ra,56(sp)
    80002aee:	f822                	sd	s0,48(sp)
    80002af0:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002af2:	00014717          	auipc	a4,0x14
    80002af6:	35272703          	lw	a4,850(a4) # 80016e44 <sb+0xc>
    80002afa:	4785                	li	a5,1
    80002afc:	06e7f463          	bgeu	a5,a4,80002b64 <ialloc+0x7a>
    80002b00:	f426                	sd	s1,40(sp)
    80002b02:	f04a                	sd	s2,32(sp)
    80002b04:	ec4e                	sd	s3,24(sp)
    80002b06:	e852                	sd	s4,16(sp)
    80002b08:	e456                	sd	s5,8(sp)
    80002b0a:	e05a                	sd	s6,0(sp)
    80002b0c:	8aaa                	mv	s5,a0
    80002b0e:	8b2e                	mv	s6,a1
    80002b10:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b12:	00014a17          	auipc	s4,0x14
    80002b16:	326a0a13          	add	s4,s4,806 # 80016e38 <sb>
    80002b1a:	00495593          	srl	a1,s2,0x4
    80002b1e:	018a2783          	lw	a5,24(s4)
    80002b22:	9dbd                	addw	a1,a1,a5
    80002b24:	8556                	mv	a0,s5
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	934080e7          	jalr	-1740(ra) # 8000245a <bread>
    80002b2e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b30:	05850993          	add	s3,a0,88
    80002b34:	00f97793          	and	a5,s2,15
    80002b38:	079a                	sll	a5,a5,0x6
    80002b3a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b3c:	00099783          	lh	a5,0(s3)
    80002b40:	cf9d                	beqz	a5,80002b7e <ialloc+0x94>
    brelse(bp);
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	a48080e7          	jalr	-1464(ra) # 8000258a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b4a:	0905                	add	s2,s2,1
    80002b4c:	00ca2703          	lw	a4,12(s4)
    80002b50:	0009079b          	sext.w	a5,s2
    80002b54:	fce7e3e3          	bltu	a5,a4,80002b1a <ialloc+0x30>
    80002b58:	74a2                	ld	s1,40(sp)
    80002b5a:	7902                	ld	s2,32(sp)
    80002b5c:	69e2                	ld	s3,24(sp)
    80002b5e:	6a42                	ld	s4,16(sp)
    80002b60:	6aa2                	ld	s5,8(sp)
    80002b62:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	91c50513          	add	a0,a0,-1764 # 80008480 <etext+0x480>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	340080e7          	jalr	832(ra) # 80005eac <printf>
  return 0;
    80002b74:	4501                	li	a0,0
}
    80002b76:	70e2                	ld	ra,56(sp)
    80002b78:	7442                	ld	s0,48(sp)
    80002b7a:	6121                	add	sp,sp,64
    80002b7c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b7e:	04000613          	li	a2,64
    80002b82:	4581                	li	a1,0
    80002b84:	854e                	mv	a0,s3
    80002b86:	ffffd097          	auipc	ra,0xffffd
    80002b8a:	63e080e7          	jalr	1598(ra) # 800001c4 <memset>
      dip->type = type;
    80002b8e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b92:	8526                	mv	a0,s1
    80002b94:	00001097          	auipc	ra,0x1
    80002b98:	ca0080e7          	jalr	-864(ra) # 80003834 <log_write>
      brelse(bp);
    80002b9c:	8526                	mv	a0,s1
    80002b9e:	00000097          	auipc	ra,0x0
    80002ba2:	9ec080e7          	jalr	-1556(ra) # 8000258a <brelse>
      return iget(dev, inum);
    80002ba6:	0009059b          	sext.w	a1,s2
    80002baa:	8556                	mv	a0,s5
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	da2080e7          	jalr	-606(ra) # 8000294e <iget>
    80002bb4:	74a2                	ld	s1,40(sp)
    80002bb6:	7902                	ld	s2,32(sp)
    80002bb8:	69e2                	ld	s3,24(sp)
    80002bba:	6a42                	ld	s4,16(sp)
    80002bbc:	6aa2                	ld	s5,8(sp)
    80002bbe:	6b02                	ld	s6,0(sp)
    80002bc0:	bf5d                	j	80002b76 <ialloc+0x8c>

0000000080002bc2 <iupdate>:
{
    80002bc2:	1101                	add	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	e04a                	sd	s2,0(sp)
    80002bcc:	1000                	add	s0,sp,32
    80002bce:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bd0:	415c                	lw	a5,4(a0)
    80002bd2:	0047d79b          	srlw	a5,a5,0x4
    80002bd6:	00014597          	auipc	a1,0x14
    80002bda:	27a5a583          	lw	a1,634(a1) # 80016e50 <sb+0x18>
    80002bde:	9dbd                	addw	a1,a1,a5
    80002be0:	4108                	lw	a0,0(a0)
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	878080e7          	jalr	-1928(ra) # 8000245a <bread>
    80002bea:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bec:	05850793          	add	a5,a0,88
    80002bf0:	40d8                	lw	a4,4(s1)
    80002bf2:	8b3d                	and	a4,a4,15
    80002bf4:	071a                	sll	a4,a4,0x6
    80002bf6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bf8:	04449703          	lh	a4,68(s1)
    80002bfc:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c00:	04649703          	lh	a4,70(s1)
    80002c04:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c08:	04849703          	lh	a4,72(s1)
    80002c0c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c10:	04a49703          	lh	a4,74(s1)
    80002c14:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c18:	44f8                	lw	a4,76(s1)
    80002c1a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c1c:	03400613          	li	a2,52
    80002c20:	05048593          	add	a1,s1,80
    80002c24:	00c78513          	add	a0,a5,12
    80002c28:	ffffd097          	auipc	ra,0xffffd
    80002c2c:	5f8080e7          	jalr	1528(ra) # 80000220 <memmove>
  log_write(bp);
    80002c30:	854a                	mv	a0,s2
    80002c32:	00001097          	auipc	ra,0x1
    80002c36:	c02080e7          	jalr	-1022(ra) # 80003834 <log_write>
  brelse(bp);
    80002c3a:	854a                	mv	a0,s2
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	94e080e7          	jalr	-1714(ra) # 8000258a <brelse>
}
    80002c44:	60e2                	ld	ra,24(sp)
    80002c46:	6442                	ld	s0,16(sp)
    80002c48:	64a2                	ld	s1,8(sp)
    80002c4a:	6902                	ld	s2,0(sp)
    80002c4c:	6105                	add	sp,sp,32
    80002c4e:	8082                	ret

0000000080002c50 <idup>:
{
    80002c50:	1101                	add	sp,sp,-32
    80002c52:	ec06                	sd	ra,24(sp)
    80002c54:	e822                	sd	s0,16(sp)
    80002c56:	e426                	sd	s1,8(sp)
    80002c58:	1000                	add	s0,sp,32
    80002c5a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c5c:	00014517          	auipc	a0,0x14
    80002c60:	1fc50513          	add	a0,a0,508 # 80016e58 <itable>
    80002c64:	00003097          	auipc	ra,0x3
    80002c68:	778080e7          	jalr	1912(ra) # 800063dc <acquire>
  ip->ref++;
    80002c6c:	449c                	lw	a5,8(s1)
    80002c6e:	2785                	addw	a5,a5,1
    80002c70:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c72:	00014517          	auipc	a0,0x14
    80002c76:	1e650513          	add	a0,a0,486 # 80016e58 <itable>
    80002c7a:	00004097          	auipc	ra,0x4
    80002c7e:	816080e7          	jalr	-2026(ra) # 80006490 <release>
}
    80002c82:	8526                	mv	a0,s1
    80002c84:	60e2                	ld	ra,24(sp)
    80002c86:	6442                	ld	s0,16(sp)
    80002c88:	64a2                	ld	s1,8(sp)
    80002c8a:	6105                	add	sp,sp,32
    80002c8c:	8082                	ret

0000000080002c8e <ilock>:
{
    80002c8e:	1101                	add	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c98:	c10d                	beqz	a0,80002cba <ilock+0x2c>
    80002c9a:	84aa                	mv	s1,a0
    80002c9c:	451c                	lw	a5,8(a0)
    80002c9e:	00f05e63          	blez	a5,80002cba <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002ca2:	0541                	add	a0,a0,16
    80002ca4:	00001097          	auipc	ra,0x1
    80002ca8:	cae080e7          	jalr	-850(ra) # 80003952 <acquiresleep>
  if(ip->valid == 0){
    80002cac:	40bc                	lw	a5,64(s1)
    80002cae:	cf99                	beqz	a5,80002ccc <ilock+0x3e>
}
    80002cb0:	60e2                	ld	ra,24(sp)
    80002cb2:	6442                	ld	s0,16(sp)
    80002cb4:	64a2                	ld	s1,8(sp)
    80002cb6:	6105                	add	sp,sp,32
    80002cb8:	8082                	ret
    80002cba:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002cbc:	00005517          	auipc	a0,0x5
    80002cc0:	7dc50513          	add	a0,a0,2012 # 80008498 <etext+0x498>
    80002cc4:	00003097          	auipc	ra,0x3
    80002cc8:	19e080e7          	jalr	414(ra) # 80005e62 <panic>
    80002ccc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cce:	40dc                	lw	a5,4(s1)
    80002cd0:	0047d79b          	srlw	a5,a5,0x4
    80002cd4:	00014597          	auipc	a1,0x14
    80002cd8:	17c5a583          	lw	a1,380(a1) # 80016e50 <sb+0x18>
    80002cdc:	9dbd                	addw	a1,a1,a5
    80002cde:	4088                	lw	a0,0(s1)
    80002ce0:	fffff097          	auipc	ra,0xfffff
    80002ce4:	77a080e7          	jalr	1914(ra) # 8000245a <bread>
    80002ce8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cea:	05850593          	add	a1,a0,88
    80002cee:	40dc                	lw	a5,4(s1)
    80002cf0:	8bbd                	and	a5,a5,15
    80002cf2:	079a                	sll	a5,a5,0x6
    80002cf4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cf6:	00059783          	lh	a5,0(a1)
    80002cfa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cfe:	00259783          	lh	a5,2(a1)
    80002d02:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d06:	00459783          	lh	a5,4(a1)
    80002d0a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d0e:	00659783          	lh	a5,6(a1)
    80002d12:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d16:	459c                	lw	a5,8(a1)
    80002d18:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d1a:	03400613          	li	a2,52
    80002d1e:	05b1                	add	a1,a1,12
    80002d20:	05048513          	add	a0,s1,80
    80002d24:	ffffd097          	auipc	ra,0xffffd
    80002d28:	4fc080e7          	jalr	1276(ra) # 80000220 <memmove>
    brelse(bp);
    80002d2c:	854a                	mv	a0,s2
    80002d2e:	00000097          	auipc	ra,0x0
    80002d32:	85c080e7          	jalr	-1956(ra) # 8000258a <brelse>
    ip->valid = 1;
    80002d36:	4785                	li	a5,1
    80002d38:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d3a:	04449783          	lh	a5,68(s1)
    80002d3e:	c399                	beqz	a5,80002d44 <ilock+0xb6>
    80002d40:	6902                	ld	s2,0(sp)
    80002d42:	b7bd                	j	80002cb0 <ilock+0x22>
      panic("ilock: no type");
    80002d44:	00005517          	auipc	a0,0x5
    80002d48:	75c50513          	add	a0,a0,1884 # 800084a0 <etext+0x4a0>
    80002d4c:	00003097          	auipc	ra,0x3
    80002d50:	116080e7          	jalr	278(ra) # 80005e62 <panic>

0000000080002d54 <iunlock>:
{
    80002d54:	1101                	add	sp,sp,-32
    80002d56:	ec06                	sd	ra,24(sp)
    80002d58:	e822                	sd	s0,16(sp)
    80002d5a:	e426                	sd	s1,8(sp)
    80002d5c:	e04a                	sd	s2,0(sp)
    80002d5e:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d60:	c905                	beqz	a0,80002d90 <iunlock+0x3c>
    80002d62:	84aa                	mv	s1,a0
    80002d64:	01050913          	add	s2,a0,16
    80002d68:	854a                	mv	a0,s2
    80002d6a:	00001097          	auipc	ra,0x1
    80002d6e:	c82080e7          	jalr	-894(ra) # 800039ec <holdingsleep>
    80002d72:	cd19                	beqz	a0,80002d90 <iunlock+0x3c>
    80002d74:	449c                	lw	a5,8(s1)
    80002d76:	00f05d63          	blez	a5,80002d90 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d7a:	854a                	mv	a0,s2
    80002d7c:	00001097          	auipc	ra,0x1
    80002d80:	c2c080e7          	jalr	-980(ra) # 800039a8 <releasesleep>
}
    80002d84:	60e2                	ld	ra,24(sp)
    80002d86:	6442                	ld	s0,16(sp)
    80002d88:	64a2                	ld	s1,8(sp)
    80002d8a:	6902                	ld	s2,0(sp)
    80002d8c:	6105                	add	sp,sp,32
    80002d8e:	8082                	ret
    panic("iunlock");
    80002d90:	00005517          	auipc	a0,0x5
    80002d94:	72050513          	add	a0,a0,1824 # 800084b0 <etext+0x4b0>
    80002d98:	00003097          	auipc	ra,0x3
    80002d9c:	0ca080e7          	jalr	202(ra) # 80005e62 <panic>

0000000080002da0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002da0:	7179                	add	sp,sp,-48
    80002da2:	f406                	sd	ra,40(sp)
    80002da4:	f022                	sd	s0,32(sp)
    80002da6:	ec26                	sd	s1,24(sp)
    80002da8:	e84a                	sd	s2,16(sp)
    80002daa:	e44e                	sd	s3,8(sp)
    80002dac:	1800                	add	s0,sp,48
    80002dae:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002db0:	05050493          	add	s1,a0,80
    80002db4:	08050913          	add	s2,a0,128
    80002db8:	a021                	j	80002dc0 <itrunc+0x20>
    80002dba:	0491                	add	s1,s1,4
    80002dbc:	01248d63          	beq	s1,s2,80002dd6 <itrunc+0x36>
    if(ip->addrs[i]){
    80002dc0:	408c                	lw	a1,0(s1)
    80002dc2:	dde5                	beqz	a1,80002dba <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002dc4:	0009a503          	lw	a0,0(s3)
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	8d6080e7          	jalr	-1834(ra) # 8000269e <bfree>
      ip->addrs[i] = 0;
    80002dd0:	0004a023          	sw	zero,0(s1)
    80002dd4:	b7dd                	j	80002dba <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dd6:	0809a583          	lw	a1,128(s3)
    80002dda:	ed99                	bnez	a1,80002df8 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ddc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002de0:	854e                	mv	a0,s3
    80002de2:	00000097          	auipc	ra,0x0
    80002de6:	de0080e7          	jalr	-544(ra) # 80002bc2 <iupdate>
}
    80002dea:	70a2                	ld	ra,40(sp)
    80002dec:	7402                	ld	s0,32(sp)
    80002dee:	64e2                	ld	s1,24(sp)
    80002df0:	6942                	ld	s2,16(sp)
    80002df2:	69a2                	ld	s3,8(sp)
    80002df4:	6145                	add	sp,sp,48
    80002df6:	8082                	ret
    80002df8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dfa:	0009a503          	lw	a0,0(s3)
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	65c080e7          	jalr	1628(ra) # 8000245a <bread>
    80002e06:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e08:	05850493          	add	s1,a0,88
    80002e0c:	45850913          	add	s2,a0,1112
    80002e10:	a021                	j	80002e18 <itrunc+0x78>
    80002e12:	0491                	add	s1,s1,4
    80002e14:	01248b63          	beq	s1,s2,80002e2a <itrunc+0x8a>
      if(a[j])
    80002e18:	408c                	lw	a1,0(s1)
    80002e1a:	dde5                	beqz	a1,80002e12 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e1c:	0009a503          	lw	a0,0(s3)
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	87e080e7          	jalr	-1922(ra) # 8000269e <bfree>
    80002e28:	b7ed                	j	80002e12 <itrunc+0x72>
    brelse(bp);
    80002e2a:	8552                	mv	a0,s4
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	75e080e7          	jalr	1886(ra) # 8000258a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e34:	0809a583          	lw	a1,128(s3)
    80002e38:	0009a503          	lw	a0,0(s3)
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	862080e7          	jalr	-1950(ra) # 8000269e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e44:	0809a023          	sw	zero,128(s3)
    80002e48:	6a02                	ld	s4,0(sp)
    80002e4a:	bf49                	j	80002ddc <itrunc+0x3c>

0000000080002e4c <iput>:
{
    80002e4c:	1101                	add	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	e426                	sd	s1,8(sp)
    80002e54:	1000                	add	s0,sp,32
    80002e56:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e58:	00014517          	auipc	a0,0x14
    80002e5c:	00050513          	mv	a0,a0
    80002e60:	00003097          	auipc	ra,0x3
    80002e64:	57c080e7          	jalr	1404(ra) # 800063dc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e68:	4498                	lw	a4,8(s1)
    80002e6a:	4785                	li	a5,1
    80002e6c:	02f70263          	beq	a4,a5,80002e90 <iput+0x44>
  ip->ref--;
    80002e70:	449c                	lw	a5,8(s1)
    80002e72:	37fd                	addw	a5,a5,-1
    80002e74:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e76:	00014517          	auipc	a0,0x14
    80002e7a:	fe250513          	add	a0,a0,-30 # 80016e58 <itable>
    80002e7e:	00003097          	auipc	ra,0x3
    80002e82:	612080e7          	jalr	1554(ra) # 80006490 <release>
}
    80002e86:	60e2                	ld	ra,24(sp)
    80002e88:	6442                	ld	s0,16(sp)
    80002e8a:	64a2                	ld	s1,8(sp)
    80002e8c:	6105                	add	sp,sp,32
    80002e8e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e90:	40bc                	lw	a5,64(s1)
    80002e92:	dff9                	beqz	a5,80002e70 <iput+0x24>
    80002e94:	04a49783          	lh	a5,74(s1)
    80002e98:	ffe1                	bnez	a5,80002e70 <iput+0x24>
    80002e9a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e9c:	01048913          	add	s2,s1,16
    80002ea0:	854a                	mv	a0,s2
    80002ea2:	00001097          	auipc	ra,0x1
    80002ea6:	ab0080e7          	jalr	-1360(ra) # 80003952 <acquiresleep>
    release(&itable.lock);
    80002eaa:	00014517          	auipc	a0,0x14
    80002eae:	fae50513          	add	a0,a0,-82 # 80016e58 <itable>
    80002eb2:	00003097          	auipc	ra,0x3
    80002eb6:	5de080e7          	jalr	1502(ra) # 80006490 <release>
    itrunc(ip);
    80002eba:	8526                	mv	a0,s1
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	ee4080e7          	jalr	-284(ra) # 80002da0 <itrunc>
    ip->type = 0;
    80002ec4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ec8:	8526                	mv	a0,s1
    80002eca:	00000097          	auipc	ra,0x0
    80002ece:	cf8080e7          	jalr	-776(ra) # 80002bc2 <iupdate>
    ip->valid = 0;
    80002ed2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ed6:	854a                	mv	a0,s2
    80002ed8:	00001097          	auipc	ra,0x1
    80002edc:	ad0080e7          	jalr	-1328(ra) # 800039a8 <releasesleep>
    acquire(&itable.lock);
    80002ee0:	00014517          	auipc	a0,0x14
    80002ee4:	f7850513          	add	a0,a0,-136 # 80016e58 <itable>
    80002ee8:	00003097          	auipc	ra,0x3
    80002eec:	4f4080e7          	jalr	1268(ra) # 800063dc <acquire>
    80002ef0:	6902                	ld	s2,0(sp)
    80002ef2:	bfbd                	j	80002e70 <iput+0x24>

0000000080002ef4 <iunlockput>:
{
    80002ef4:	1101                	add	sp,sp,-32
    80002ef6:	ec06                	sd	ra,24(sp)
    80002ef8:	e822                	sd	s0,16(sp)
    80002efa:	e426                	sd	s1,8(sp)
    80002efc:	1000                	add	s0,sp,32
    80002efe:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	e54080e7          	jalr	-428(ra) # 80002d54 <iunlock>
  iput(ip);
    80002f08:	8526                	mv	a0,s1
    80002f0a:	00000097          	auipc	ra,0x0
    80002f0e:	f42080e7          	jalr	-190(ra) # 80002e4c <iput>
}
    80002f12:	60e2                	ld	ra,24(sp)
    80002f14:	6442                	ld	s0,16(sp)
    80002f16:	64a2                	ld	s1,8(sp)
    80002f18:	6105                	add	sp,sp,32
    80002f1a:	8082                	ret

0000000080002f1c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f1c:	1141                	add	sp,sp,-16
    80002f1e:	e422                	sd	s0,8(sp)
    80002f20:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80002f22:	411c                	lw	a5,0(a0)
    80002f24:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f26:	415c                	lw	a5,4(a0)
    80002f28:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f2a:	04451783          	lh	a5,68(a0)
    80002f2e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f32:	04a51783          	lh	a5,74(a0)
    80002f36:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f3a:	04c56783          	lwu	a5,76(a0)
    80002f3e:	e99c                	sd	a5,16(a1)
}
    80002f40:	6422                	ld	s0,8(sp)
    80002f42:	0141                	add	sp,sp,16
    80002f44:	8082                	ret

0000000080002f46 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f46:	457c                	lw	a5,76(a0)
    80002f48:	10d7e563          	bltu	a5,a3,80003052 <readi+0x10c>
{
    80002f4c:	7159                	add	sp,sp,-112
    80002f4e:	f486                	sd	ra,104(sp)
    80002f50:	f0a2                	sd	s0,96(sp)
    80002f52:	eca6                	sd	s1,88(sp)
    80002f54:	e0d2                	sd	s4,64(sp)
    80002f56:	fc56                	sd	s5,56(sp)
    80002f58:	f85a                	sd	s6,48(sp)
    80002f5a:	f45e                	sd	s7,40(sp)
    80002f5c:	1880                	add	s0,sp,112
    80002f5e:	8b2a                	mv	s6,a0
    80002f60:	8bae                	mv	s7,a1
    80002f62:	8a32                	mv	s4,a2
    80002f64:	84b6                	mv	s1,a3
    80002f66:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f68:	9f35                	addw	a4,a4,a3
    return 0;
    80002f6a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f6c:	0cd76a63          	bltu	a4,a3,80003040 <readi+0xfa>
    80002f70:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f72:	00e7f463          	bgeu	a5,a4,80002f7a <readi+0x34>
    n = ip->size - off;
    80002f76:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f7a:	0a0a8963          	beqz	s5,8000302c <readi+0xe6>
    80002f7e:	e8ca                	sd	s2,80(sp)
    80002f80:	f062                	sd	s8,32(sp)
    80002f82:	ec66                	sd	s9,24(sp)
    80002f84:	e86a                	sd	s10,16(sp)
    80002f86:	e46e                	sd	s11,8(sp)
    80002f88:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f8e:	5c7d                	li	s8,-1
    80002f90:	a82d                	j	80002fca <readi+0x84>
    80002f92:	020d1d93          	sll	s11,s10,0x20
    80002f96:	020ddd93          	srl	s11,s11,0x20
    80002f9a:	05890613          	add	a2,s2,88
    80002f9e:	86ee                	mv	a3,s11
    80002fa0:	963a                	add	a2,a2,a4
    80002fa2:	85d2                	mv	a1,s4
    80002fa4:	855e                	mv	a0,s7
    80002fa6:	fffff097          	auipc	ra,0xfffff
    80002faa:	a60080e7          	jalr	-1440(ra) # 80001a06 <either_copyout>
    80002fae:	05850d63          	beq	a0,s8,80003008 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	5d6080e7          	jalr	1494(ra) # 8000258a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fbc:	013d09bb          	addw	s3,s10,s3
    80002fc0:	009d04bb          	addw	s1,s10,s1
    80002fc4:	9a6e                	add	s4,s4,s11
    80002fc6:	0559fd63          	bgeu	s3,s5,80003020 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80002fca:	00a4d59b          	srlw	a1,s1,0xa
    80002fce:	855a                	mv	a0,s6
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	88e080e7          	jalr	-1906(ra) # 8000285e <bmap>
    80002fd8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fdc:	c9b1                	beqz	a1,80003030 <readi+0xea>
    bp = bread(ip->dev, addr);
    80002fde:	000b2503          	lw	a0,0(s6)
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	478080e7          	jalr	1144(ra) # 8000245a <bread>
    80002fea:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fec:	3ff4f713          	and	a4,s1,1023
    80002ff0:	40ec87bb          	subw	a5,s9,a4
    80002ff4:	413a86bb          	subw	a3,s5,s3
    80002ff8:	8d3e                	mv	s10,a5
    80002ffa:	2781                	sext.w	a5,a5
    80002ffc:	0006861b          	sext.w	a2,a3
    80003000:	f8f679e3          	bgeu	a2,a5,80002f92 <readi+0x4c>
    80003004:	8d36                	mv	s10,a3
    80003006:	b771                	j	80002f92 <readi+0x4c>
      brelse(bp);
    80003008:	854a                	mv	a0,s2
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	580080e7          	jalr	1408(ra) # 8000258a <brelse>
      tot = -1;
    80003012:	59fd                	li	s3,-1
      break;
    80003014:	6946                	ld	s2,80(sp)
    80003016:	7c02                	ld	s8,32(sp)
    80003018:	6ce2                	ld	s9,24(sp)
    8000301a:	6d42                	ld	s10,16(sp)
    8000301c:	6da2                	ld	s11,8(sp)
    8000301e:	a831                	j	8000303a <readi+0xf4>
    80003020:	6946                	ld	s2,80(sp)
    80003022:	7c02                	ld	s8,32(sp)
    80003024:	6ce2                	ld	s9,24(sp)
    80003026:	6d42                	ld	s10,16(sp)
    80003028:	6da2                	ld	s11,8(sp)
    8000302a:	a801                	j	8000303a <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000302c:	89d6                	mv	s3,s5
    8000302e:	a031                	j	8000303a <readi+0xf4>
    80003030:	6946                	ld	s2,80(sp)
    80003032:	7c02                	ld	s8,32(sp)
    80003034:	6ce2                	ld	s9,24(sp)
    80003036:	6d42                	ld	s10,16(sp)
    80003038:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000303a:	0009851b          	sext.w	a0,s3
    8000303e:	69a6                	ld	s3,72(sp)
}
    80003040:	70a6                	ld	ra,104(sp)
    80003042:	7406                	ld	s0,96(sp)
    80003044:	64e6                	ld	s1,88(sp)
    80003046:	6a06                	ld	s4,64(sp)
    80003048:	7ae2                	ld	s5,56(sp)
    8000304a:	7b42                	ld	s6,48(sp)
    8000304c:	7ba2                	ld	s7,40(sp)
    8000304e:	6165                	add	sp,sp,112
    80003050:	8082                	ret
    return 0;
    80003052:	4501                	li	a0,0
}
    80003054:	8082                	ret

0000000080003056 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003056:	457c                	lw	a5,76(a0)
    80003058:	10d7ee63          	bltu	a5,a3,80003174 <writei+0x11e>
{
    8000305c:	7159                	add	sp,sp,-112
    8000305e:	f486                	sd	ra,104(sp)
    80003060:	f0a2                	sd	s0,96(sp)
    80003062:	e8ca                	sd	s2,80(sp)
    80003064:	e0d2                	sd	s4,64(sp)
    80003066:	fc56                	sd	s5,56(sp)
    80003068:	f85a                	sd	s6,48(sp)
    8000306a:	f45e                	sd	s7,40(sp)
    8000306c:	1880                	add	s0,sp,112
    8000306e:	8aaa                	mv	s5,a0
    80003070:	8bae                	mv	s7,a1
    80003072:	8a32                	mv	s4,a2
    80003074:	8936                	mv	s2,a3
    80003076:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003078:	00e687bb          	addw	a5,a3,a4
    8000307c:	0ed7ee63          	bltu	a5,a3,80003178 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003080:	00043737          	lui	a4,0x43
    80003084:	0ef76c63          	bltu	a4,a5,8000317c <writei+0x126>
    80003088:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000308a:	0c0b0d63          	beqz	s6,80003164 <writei+0x10e>
    8000308e:	eca6                	sd	s1,88(sp)
    80003090:	f062                	sd	s8,32(sp)
    80003092:	ec66                	sd	s9,24(sp)
    80003094:	e86a                	sd	s10,16(sp)
    80003096:	e46e                	sd	s11,8(sp)
    80003098:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000309a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000309e:	5c7d                	li	s8,-1
    800030a0:	a091                	j	800030e4 <writei+0x8e>
    800030a2:	020d1d93          	sll	s11,s10,0x20
    800030a6:	020ddd93          	srl	s11,s11,0x20
    800030aa:	05848513          	add	a0,s1,88
    800030ae:	86ee                	mv	a3,s11
    800030b0:	8652                	mv	a2,s4
    800030b2:	85de                	mv	a1,s7
    800030b4:	953a                	add	a0,a0,a4
    800030b6:	fffff097          	auipc	ra,0xfffff
    800030ba:	9a6080e7          	jalr	-1626(ra) # 80001a5c <either_copyin>
    800030be:	07850263          	beq	a0,s8,80003122 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030c2:	8526                	mv	a0,s1
    800030c4:	00000097          	auipc	ra,0x0
    800030c8:	770080e7          	jalr	1904(ra) # 80003834 <log_write>
    brelse(bp);
    800030cc:	8526                	mv	a0,s1
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	4bc080e7          	jalr	1212(ra) # 8000258a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d6:	013d09bb          	addw	s3,s10,s3
    800030da:	012d093b          	addw	s2,s10,s2
    800030de:	9a6e                	add	s4,s4,s11
    800030e0:	0569f663          	bgeu	s3,s6,8000312c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030e4:	00a9559b          	srlw	a1,s2,0xa
    800030e8:	8556                	mv	a0,s5
    800030ea:	fffff097          	auipc	ra,0xfffff
    800030ee:	774080e7          	jalr	1908(ra) # 8000285e <bmap>
    800030f2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030f6:	c99d                	beqz	a1,8000312c <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030f8:	000aa503          	lw	a0,0(s5)
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	35e080e7          	jalr	862(ra) # 8000245a <bread>
    80003104:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003106:	3ff97713          	and	a4,s2,1023
    8000310a:	40ec87bb          	subw	a5,s9,a4
    8000310e:	413b06bb          	subw	a3,s6,s3
    80003112:	8d3e                	mv	s10,a5
    80003114:	2781                	sext.w	a5,a5
    80003116:	0006861b          	sext.w	a2,a3
    8000311a:	f8f674e3          	bgeu	a2,a5,800030a2 <writei+0x4c>
    8000311e:	8d36                	mv	s10,a3
    80003120:	b749                	j	800030a2 <writei+0x4c>
      brelse(bp);
    80003122:	8526                	mv	a0,s1
    80003124:	fffff097          	auipc	ra,0xfffff
    80003128:	466080e7          	jalr	1126(ra) # 8000258a <brelse>
  }

  if(off > ip->size)
    8000312c:	04caa783          	lw	a5,76(s5)
    80003130:	0327fc63          	bgeu	a5,s2,80003168 <writei+0x112>
    ip->size = off;
    80003134:	052aa623          	sw	s2,76(s5)
    80003138:	64e6                	ld	s1,88(sp)
    8000313a:	7c02                	ld	s8,32(sp)
    8000313c:	6ce2                	ld	s9,24(sp)
    8000313e:	6d42                	ld	s10,16(sp)
    80003140:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003142:	8556                	mv	a0,s5
    80003144:	00000097          	auipc	ra,0x0
    80003148:	a7e080e7          	jalr	-1410(ra) # 80002bc2 <iupdate>

  return tot;
    8000314c:	0009851b          	sext.w	a0,s3
    80003150:	69a6                	ld	s3,72(sp)
}
    80003152:	70a6                	ld	ra,104(sp)
    80003154:	7406                	ld	s0,96(sp)
    80003156:	6946                	ld	s2,80(sp)
    80003158:	6a06                	ld	s4,64(sp)
    8000315a:	7ae2                	ld	s5,56(sp)
    8000315c:	7b42                	ld	s6,48(sp)
    8000315e:	7ba2                	ld	s7,40(sp)
    80003160:	6165                	add	sp,sp,112
    80003162:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003164:	89da                	mv	s3,s6
    80003166:	bff1                	j	80003142 <writei+0xec>
    80003168:	64e6                	ld	s1,88(sp)
    8000316a:	7c02                	ld	s8,32(sp)
    8000316c:	6ce2                	ld	s9,24(sp)
    8000316e:	6d42                	ld	s10,16(sp)
    80003170:	6da2                	ld	s11,8(sp)
    80003172:	bfc1                	j	80003142 <writei+0xec>
    return -1;
    80003174:	557d                	li	a0,-1
}
    80003176:	8082                	ret
    return -1;
    80003178:	557d                	li	a0,-1
    8000317a:	bfe1                	j	80003152 <writei+0xfc>
    return -1;
    8000317c:	557d                	li	a0,-1
    8000317e:	bfd1                	j	80003152 <writei+0xfc>

0000000080003180 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003180:	1141                	add	sp,sp,-16
    80003182:	e406                	sd	ra,8(sp)
    80003184:	e022                	sd	s0,0(sp)
    80003186:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003188:	4639                	li	a2,14
    8000318a:	ffffd097          	auipc	ra,0xffffd
    8000318e:	10a080e7          	jalr	266(ra) # 80000294 <strncmp>
}
    80003192:	60a2                	ld	ra,8(sp)
    80003194:	6402                	ld	s0,0(sp)
    80003196:	0141                	add	sp,sp,16
    80003198:	8082                	ret

000000008000319a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000319a:	7139                	add	sp,sp,-64
    8000319c:	fc06                	sd	ra,56(sp)
    8000319e:	f822                	sd	s0,48(sp)
    800031a0:	f426                	sd	s1,40(sp)
    800031a2:	f04a                	sd	s2,32(sp)
    800031a4:	ec4e                	sd	s3,24(sp)
    800031a6:	e852                	sd	s4,16(sp)
    800031a8:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031aa:	04451703          	lh	a4,68(a0)
    800031ae:	4785                	li	a5,1
    800031b0:	00f71a63          	bne	a4,a5,800031c4 <dirlookup+0x2a>
    800031b4:	892a                	mv	s2,a0
    800031b6:	89ae                	mv	s3,a1
    800031b8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ba:	457c                	lw	a5,76(a0)
    800031bc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031be:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c0:	e79d                	bnez	a5,800031ee <dirlookup+0x54>
    800031c2:	a8a5                	j	8000323a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031c4:	00005517          	auipc	a0,0x5
    800031c8:	2f450513          	add	a0,a0,756 # 800084b8 <etext+0x4b8>
    800031cc:	00003097          	auipc	ra,0x3
    800031d0:	c96080e7          	jalr	-874(ra) # 80005e62 <panic>
      panic("dirlookup read");
    800031d4:	00005517          	auipc	a0,0x5
    800031d8:	2fc50513          	add	a0,a0,764 # 800084d0 <etext+0x4d0>
    800031dc:	00003097          	auipc	ra,0x3
    800031e0:	c86080e7          	jalr	-890(ra) # 80005e62 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e4:	24c1                	addw	s1,s1,16
    800031e6:	04c92783          	lw	a5,76(s2)
    800031ea:	04f4f763          	bgeu	s1,a5,80003238 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ee:	4741                	li	a4,16
    800031f0:	86a6                	mv	a3,s1
    800031f2:	fc040613          	add	a2,s0,-64
    800031f6:	4581                	li	a1,0
    800031f8:	854a                	mv	a0,s2
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	d4c080e7          	jalr	-692(ra) # 80002f46 <readi>
    80003202:	47c1                	li	a5,16
    80003204:	fcf518e3          	bne	a0,a5,800031d4 <dirlookup+0x3a>
    if(de.inum == 0)
    80003208:	fc045783          	lhu	a5,-64(s0)
    8000320c:	dfe1                	beqz	a5,800031e4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000320e:	fc240593          	add	a1,s0,-62
    80003212:	854e                	mv	a0,s3
    80003214:	00000097          	auipc	ra,0x0
    80003218:	f6c080e7          	jalr	-148(ra) # 80003180 <namecmp>
    8000321c:	f561                	bnez	a0,800031e4 <dirlookup+0x4a>
      if(poff)
    8000321e:	000a0463          	beqz	s4,80003226 <dirlookup+0x8c>
        *poff = off;
    80003222:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003226:	fc045583          	lhu	a1,-64(s0)
    8000322a:	00092503          	lw	a0,0(s2)
    8000322e:	fffff097          	auipc	ra,0xfffff
    80003232:	720080e7          	jalr	1824(ra) # 8000294e <iget>
    80003236:	a011                	j	8000323a <dirlookup+0xa0>
  return 0;
    80003238:	4501                	li	a0,0
}
    8000323a:	70e2                	ld	ra,56(sp)
    8000323c:	7442                	ld	s0,48(sp)
    8000323e:	74a2                	ld	s1,40(sp)
    80003240:	7902                	ld	s2,32(sp)
    80003242:	69e2                	ld	s3,24(sp)
    80003244:	6a42                	ld	s4,16(sp)
    80003246:	6121                	add	sp,sp,64
    80003248:	8082                	ret

000000008000324a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000324a:	711d                	add	sp,sp,-96
    8000324c:	ec86                	sd	ra,88(sp)
    8000324e:	e8a2                	sd	s0,80(sp)
    80003250:	e4a6                	sd	s1,72(sp)
    80003252:	e0ca                	sd	s2,64(sp)
    80003254:	fc4e                	sd	s3,56(sp)
    80003256:	f852                	sd	s4,48(sp)
    80003258:	f456                	sd	s5,40(sp)
    8000325a:	f05a                	sd	s6,32(sp)
    8000325c:	ec5e                	sd	s7,24(sp)
    8000325e:	e862                	sd	s8,16(sp)
    80003260:	e466                	sd	s9,8(sp)
    80003262:	1080                	add	s0,sp,96
    80003264:	84aa                	mv	s1,a0
    80003266:	8b2e                	mv	s6,a1
    80003268:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000326a:	00054703          	lbu	a4,0(a0)
    8000326e:	02f00793          	li	a5,47
    80003272:	02f70263          	beq	a4,a5,80003296 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003276:	ffffe097          	auipc	ra,0xffffe
    8000327a:	cda080e7          	jalr	-806(ra) # 80000f50 <myproc>
    8000327e:	15053503          	ld	a0,336(a0)
    80003282:	00000097          	auipc	ra,0x0
    80003286:	9ce080e7          	jalr	-1586(ra) # 80002c50 <idup>
    8000328a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000328c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003290:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003292:	4b85                	li	s7,1
    80003294:	a875                	j	80003350 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003296:	4585                	li	a1,1
    80003298:	4505                	li	a0,1
    8000329a:	fffff097          	auipc	ra,0xfffff
    8000329e:	6b4080e7          	jalr	1716(ra) # 8000294e <iget>
    800032a2:	8a2a                	mv	s4,a0
    800032a4:	b7e5                	j	8000328c <namex+0x42>
      iunlockput(ip);
    800032a6:	8552                	mv	a0,s4
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	c4c080e7          	jalr	-948(ra) # 80002ef4 <iunlockput>
      return 0;
    800032b0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032b2:	8552                	mv	a0,s4
    800032b4:	60e6                	ld	ra,88(sp)
    800032b6:	6446                	ld	s0,80(sp)
    800032b8:	64a6                	ld	s1,72(sp)
    800032ba:	6906                	ld	s2,64(sp)
    800032bc:	79e2                	ld	s3,56(sp)
    800032be:	7a42                	ld	s4,48(sp)
    800032c0:	7aa2                	ld	s5,40(sp)
    800032c2:	7b02                	ld	s6,32(sp)
    800032c4:	6be2                	ld	s7,24(sp)
    800032c6:	6c42                	ld	s8,16(sp)
    800032c8:	6ca2                	ld	s9,8(sp)
    800032ca:	6125                	add	sp,sp,96
    800032cc:	8082                	ret
      iunlock(ip);
    800032ce:	8552                	mv	a0,s4
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	a84080e7          	jalr	-1404(ra) # 80002d54 <iunlock>
      return ip;
    800032d8:	bfe9                	j	800032b2 <namex+0x68>
      iunlockput(ip);
    800032da:	8552                	mv	a0,s4
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	c18080e7          	jalr	-1000(ra) # 80002ef4 <iunlockput>
      return 0;
    800032e4:	8a4e                	mv	s4,s3
    800032e6:	b7f1                	j	800032b2 <namex+0x68>
  len = path - s;
    800032e8:	40998633          	sub	a2,s3,s1
    800032ec:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800032f0:	099c5863          	bge	s8,s9,80003380 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800032f4:	4639                	li	a2,14
    800032f6:	85a6                	mv	a1,s1
    800032f8:	8556                	mv	a0,s5
    800032fa:	ffffd097          	auipc	ra,0xffffd
    800032fe:	f26080e7          	jalr	-218(ra) # 80000220 <memmove>
    80003302:	84ce                	mv	s1,s3
  while(*path == '/')
    80003304:	0004c783          	lbu	a5,0(s1)
    80003308:	01279763          	bne	a5,s2,80003316 <namex+0xcc>
    path++;
    8000330c:	0485                	add	s1,s1,1
  while(*path == '/')
    8000330e:	0004c783          	lbu	a5,0(s1)
    80003312:	ff278de3          	beq	a5,s2,8000330c <namex+0xc2>
    ilock(ip);
    80003316:	8552                	mv	a0,s4
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	976080e7          	jalr	-1674(ra) # 80002c8e <ilock>
    if(ip->type != T_DIR){
    80003320:	044a1783          	lh	a5,68(s4)
    80003324:	f97791e3          	bne	a5,s7,800032a6 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003328:	000b0563          	beqz	s6,80003332 <namex+0xe8>
    8000332c:	0004c783          	lbu	a5,0(s1)
    80003330:	dfd9                	beqz	a5,800032ce <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003332:	4601                	li	a2,0
    80003334:	85d6                	mv	a1,s5
    80003336:	8552                	mv	a0,s4
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	e62080e7          	jalr	-414(ra) # 8000319a <dirlookup>
    80003340:	89aa                	mv	s3,a0
    80003342:	dd41                	beqz	a0,800032da <namex+0x90>
    iunlockput(ip);
    80003344:	8552                	mv	a0,s4
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	bae080e7          	jalr	-1106(ra) # 80002ef4 <iunlockput>
    ip = next;
    8000334e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003350:	0004c783          	lbu	a5,0(s1)
    80003354:	01279763          	bne	a5,s2,80003362 <namex+0x118>
    path++;
    80003358:	0485                	add	s1,s1,1
  while(*path == '/')
    8000335a:	0004c783          	lbu	a5,0(s1)
    8000335e:	ff278de3          	beq	a5,s2,80003358 <namex+0x10e>
  if(*path == 0)
    80003362:	cb9d                	beqz	a5,80003398 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003364:	0004c783          	lbu	a5,0(s1)
    80003368:	89a6                	mv	s3,s1
  len = path - s;
    8000336a:	4c81                	li	s9,0
    8000336c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000336e:	01278963          	beq	a5,s2,80003380 <namex+0x136>
    80003372:	dbbd                	beqz	a5,800032e8 <namex+0x9e>
    path++;
    80003374:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003376:	0009c783          	lbu	a5,0(s3)
    8000337a:	ff279ce3          	bne	a5,s2,80003372 <namex+0x128>
    8000337e:	b7ad                	j	800032e8 <namex+0x9e>
    memmove(name, s, len);
    80003380:	2601                	sext.w	a2,a2
    80003382:	85a6                	mv	a1,s1
    80003384:	8556                	mv	a0,s5
    80003386:	ffffd097          	auipc	ra,0xffffd
    8000338a:	e9a080e7          	jalr	-358(ra) # 80000220 <memmove>
    name[len] = 0;
    8000338e:	9cd6                	add	s9,s9,s5
    80003390:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003394:	84ce                	mv	s1,s3
    80003396:	b7bd                	j	80003304 <namex+0xba>
  if(nameiparent){
    80003398:	f00b0de3          	beqz	s6,800032b2 <namex+0x68>
    iput(ip);
    8000339c:	8552                	mv	a0,s4
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	aae080e7          	jalr	-1362(ra) # 80002e4c <iput>
    return 0;
    800033a6:	4a01                	li	s4,0
    800033a8:	b729                	j	800032b2 <namex+0x68>

00000000800033aa <dirlink>:
{
    800033aa:	7139                	add	sp,sp,-64
    800033ac:	fc06                	sd	ra,56(sp)
    800033ae:	f822                	sd	s0,48(sp)
    800033b0:	f04a                	sd	s2,32(sp)
    800033b2:	ec4e                	sd	s3,24(sp)
    800033b4:	e852                	sd	s4,16(sp)
    800033b6:	0080                	add	s0,sp,64
    800033b8:	892a                	mv	s2,a0
    800033ba:	8a2e                	mv	s4,a1
    800033bc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033be:	4601                	li	a2,0
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	dda080e7          	jalr	-550(ra) # 8000319a <dirlookup>
    800033c8:	ed25                	bnez	a0,80003440 <dirlink+0x96>
    800033ca:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033cc:	04c92483          	lw	s1,76(s2)
    800033d0:	c49d                	beqz	s1,800033fe <dirlink+0x54>
    800033d2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033d4:	4741                	li	a4,16
    800033d6:	86a6                	mv	a3,s1
    800033d8:	fc040613          	add	a2,s0,-64
    800033dc:	4581                	li	a1,0
    800033de:	854a                	mv	a0,s2
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	b66080e7          	jalr	-1178(ra) # 80002f46 <readi>
    800033e8:	47c1                	li	a5,16
    800033ea:	06f51163          	bne	a0,a5,8000344c <dirlink+0xa2>
    if(de.inum == 0)
    800033ee:	fc045783          	lhu	a5,-64(s0)
    800033f2:	c791                	beqz	a5,800033fe <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033f4:	24c1                	addw	s1,s1,16
    800033f6:	04c92783          	lw	a5,76(s2)
    800033fa:	fcf4ede3          	bltu	s1,a5,800033d4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033fe:	4639                	li	a2,14
    80003400:	85d2                	mv	a1,s4
    80003402:	fc240513          	add	a0,s0,-62
    80003406:	ffffd097          	auipc	ra,0xffffd
    8000340a:	ec4080e7          	jalr	-316(ra) # 800002ca <strncpy>
  de.inum = inum;
    8000340e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003412:	4741                	li	a4,16
    80003414:	86a6                	mv	a3,s1
    80003416:	fc040613          	add	a2,s0,-64
    8000341a:	4581                	li	a1,0
    8000341c:	854a                	mv	a0,s2
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	c38080e7          	jalr	-968(ra) # 80003056 <writei>
    80003426:	1541                	add	a0,a0,-16
    80003428:	00a03533          	snez	a0,a0
    8000342c:	40a00533          	neg	a0,a0
    80003430:	74a2                	ld	s1,40(sp)
}
    80003432:	70e2                	ld	ra,56(sp)
    80003434:	7442                	ld	s0,48(sp)
    80003436:	7902                	ld	s2,32(sp)
    80003438:	69e2                	ld	s3,24(sp)
    8000343a:	6a42                	ld	s4,16(sp)
    8000343c:	6121                	add	sp,sp,64
    8000343e:	8082                	ret
    iput(ip);
    80003440:	00000097          	auipc	ra,0x0
    80003444:	a0c080e7          	jalr	-1524(ra) # 80002e4c <iput>
    return -1;
    80003448:	557d                	li	a0,-1
    8000344a:	b7e5                	j	80003432 <dirlink+0x88>
      panic("dirlink read");
    8000344c:	00005517          	auipc	a0,0x5
    80003450:	09450513          	add	a0,a0,148 # 800084e0 <etext+0x4e0>
    80003454:	00003097          	auipc	ra,0x3
    80003458:	a0e080e7          	jalr	-1522(ra) # 80005e62 <panic>

000000008000345c <namei>:

struct inode*
namei(char *path)
{
    8000345c:	1101                	add	sp,sp,-32
    8000345e:	ec06                	sd	ra,24(sp)
    80003460:	e822                	sd	s0,16(sp)
    80003462:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003464:	fe040613          	add	a2,s0,-32
    80003468:	4581                	li	a1,0
    8000346a:	00000097          	auipc	ra,0x0
    8000346e:	de0080e7          	jalr	-544(ra) # 8000324a <namex>
}
    80003472:	60e2                	ld	ra,24(sp)
    80003474:	6442                	ld	s0,16(sp)
    80003476:	6105                	add	sp,sp,32
    80003478:	8082                	ret

000000008000347a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000347a:	1141                	add	sp,sp,-16
    8000347c:	e406                	sd	ra,8(sp)
    8000347e:	e022                	sd	s0,0(sp)
    80003480:	0800                	add	s0,sp,16
    80003482:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003484:	4585                	li	a1,1
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	dc4080e7          	jalr	-572(ra) # 8000324a <namex>
}
    8000348e:	60a2                	ld	ra,8(sp)
    80003490:	6402                	ld	s0,0(sp)
    80003492:	0141                	add	sp,sp,16
    80003494:	8082                	ret

0000000080003496 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003496:	1101                	add	sp,sp,-32
    80003498:	ec06                	sd	ra,24(sp)
    8000349a:	e822                	sd	s0,16(sp)
    8000349c:	e426                	sd	s1,8(sp)
    8000349e:	e04a                	sd	s2,0(sp)
    800034a0:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034a2:	00015917          	auipc	s2,0x15
    800034a6:	45e90913          	add	s2,s2,1118 # 80018900 <log>
    800034aa:	01892583          	lw	a1,24(s2)
    800034ae:	02892503          	lw	a0,40(s2)
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	fa8080e7          	jalr	-88(ra) # 8000245a <bread>
    800034ba:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034bc:	02c92603          	lw	a2,44(s2)
    800034c0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034c2:	00c05f63          	blez	a2,800034e0 <write_head+0x4a>
    800034c6:	00015717          	auipc	a4,0x15
    800034ca:	46a70713          	add	a4,a4,1130 # 80018930 <log+0x30>
    800034ce:	87aa                	mv	a5,a0
    800034d0:	060a                	sll	a2,a2,0x2
    800034d2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800034d4:	4314                	lw	a3,0(a4)
    800034d6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034d8:	0711                	add	a4,a4,4
    800034da:	0791                	add	a5,a5,4
    800034dc:	fec79ce3          	bne	a5,a2,800034d4 <write_head+0x3e>
  }
  bwrite(buf);
    800034e0:	8526                	mv	a0,s1
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	06a080e7          	jalr	106(ra) # 8000254c <bwrite>
  brelse(buf);
    800034ea:	8526                	mv	a0,s1
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	09e080e7          	jalr	158(ra) # 8000258a <brelse>
}
    800034f4:	60e2                	ld	ra,24(sp)
    800034f6:	6442                	ld	s0,16(sp)
    800034f8:	64a2                	ld	s1,8(sp)
    800034fa:	6902                	ld	s2,0(sp)
    800034fc:	6105                	add	sp,sp,32
    800034fe:	8082                	ret

0000000080003500 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003500:	00015797          	auipc	a5,0x15
    80003504:	42c7a783          	lw	a5,1068(a5) # 8001892c <log+0x2c>
    80003508:	0af05d63          	blez	a5,800035c2 <install_trans+0xc2>
{
    8000350c:	7139                	add	sp,sp,-64
    8000350e:	fc06                	sd	ra,56(sp)
    80003510:	f822                	sd	s0,48(sp)
    80003512:	f426                	sd	s1,40(sp)
    80003514:	f04a                	sd	s2,32(sp)
    80003516:	ec4e                	sd	s3,24(sp)
    80003518:	e852                	sd	s4,16(sp)
    8000351a:	e456                	sd	s5,8(sp)
    8000351c:	e05a                	sd	s6,0(sp)
    8000351e:	0080                	add	s0,sp,64
    80003520:	8b2a                	mv	s6,a0
    80003522:	00015a97          	auipc	s5,0x15
    80003526:	40ea8a93          	add	s5,s5,1038 # 80018930 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000352c:	00015997          	auipc	s3,0x15
    80003530:	3d498993          	add	s3,s3,980 # 80018900 <log>
    80003534:	a00d                	j	80003556 <install_trans+0x56>
    brelse(lbuf);
    80003536:	854a                	mv	a0,s2
    80003538:	fffff097          	auipc	ra,0xfffff
    8000353c:	052080e7          	jalr	82(ra) # 8000258a <brelse>
    brelse(dbuf);
    80003540:	8526                	mv	a0,s1
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	048080e7          	jalr	72(ra) # 8000258a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000354a:	2a05                	addw	s4,s4,1
    8000354c:	0a91                	add	s5,s5,4
    8000354e:	02c9a783          	lw	a5,44(s3)
    80003552:	04fa5e63          	bge	s4,a5,800035ae <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003556:	0189a583          	lw	a1,24(s3)
    8000355a:	014585bb          	addw	a1,a1,s4
    8000355e:	2585                	addw	a1,a1,1
    80003560:	0289a503          	lw	a0,40(s3)
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	ef6080e7          	jalr	-266(ra) # 8000245a <bread>
    8000356c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000356e:	000aa583          	lw	a1,0(s5)
    80003572:	0289a503          	lw	a0,40(s3)
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	ee4080e7          	jalr	-284(ra) # 8000245a <bread>
    8000357e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003580:	40000613          	li	a2,1024
    80003584:	05890593          	add	a1,s2,88
    80003588:	05850513          	add	a0,a0,88
    8000358c:	ffffd097          	auipc	ra,0xffffd
    80003590:	c94080e7          	jalr	-876(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003594:	8526                	mv	a0,s1
    80003596:	fffff097          	auipc	ra,0xfffff
    8000359a:	fb6080e7          	jalr	-74(ra) # 8000254c <bwrite>
    if(recovering == 0)
    8000359e:	f80b1ce3          	bnez	s6,80003536 <install_trans+0x36>
      bunpin(dbuf);
    800035a2:	8526                	mv	a0,s1
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	0be080e7          	jalr	190(ra) # 80002662 <bunpin>
    800035ac:	b769                	j	80003536 <install_trans+0x36>
}
    800035ae:	70e2                	ld	ra,56(sp)
    800035b0:	7442                	ld	s0,48(sp)
    800035b2:	74a2                	ld	s1,40(sp)
    800035b4:	7902                	ld	s2,32(sp)
    800035b6:	69e2                	ld	s3,24(sp)
    800035b8:	6a42                	ld	s4,16(sp)
    800035ba:	6aa2                	ld	s5,8(sp)
    800035bc:	6b02                	ld	s6,0(sp)
    800035be:	6121                	add	sp,sp,64
    800035c0:	8082                	ret
    800035c2:	8082                	ret

00000000800035c4 <initlog>:
{
    800035c4:	7179                	add	sp,sp,-48
    800035c6:	f406                	sd	ra,40(sp)
    800035c8:	f022                	sd	s0,32(sp)
    800035ca:	ec26                	sd	s1,24(sp)
    800035cc:	e84a                	sd	s2,16(sp)
    800035ce:	e44e                	sd	s3,8(sp)
    800035d0:	1800                	add	s0,sp,48
    800035d2:	892a                	mv	s2,a0
    800035d4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035d6:	00015497          	auipc	s1,0x15
    800035da:	32a48493          	add	s1,s1,810 # 80018900 <log>
    800035de:	00005597          	auipc	a1,0x5
    800035e2:	f1258593          	add	a1,a1,-238 # 800084f0 <etext+0x4f0>
    800035e6:	8526                	mv	a0,s1
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	d64080e7          	jalr	-668(ra) # 8000634c <initlock>
  log.start = sb->logstart;
    800035f0:	0149a583          	lw	a1,20(s3)
    800035f4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035f6:	0109a783          	lw	a5,16(s3)
    800035fa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035fc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003600:	854a                	mv	a0,s2
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	e58080e7          	jalr	-424(ra) # 8000245a <bread>
  log.lh.n = lh->n;
    8000360a:	4d30                	lw	a2,88(a0)
    8000360c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000360e:	00c05f63          	blez	a2,8000362c <initlog+0x68>
    80003612:	87aa                	mv	a5,a0
    80003614:	00015717          	auipc	a4,0x15
    80003618:	31c70713          	add	a4,a4,796 # 80018930 <log+0x30>
    8000361c:	060a                	sll	a2,a2,0x2
    8000361e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003620:	4ff4                	lw	a3,92(a5)
    80003622:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003624:	0791                	add	a5,a5,4
    80003626:	0711                	add	a4,a4,4
    80003628:	fec79ce3          	bne	a5,a2,80003620 <initlog+0x5c>
  brelse(buf);
    8000362c:	fffff097          	auipc	ra,0xfffff
    80003630:	f5e080e7          	jalr	-162(ra) # 8000258a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003634:	4505                	li	a0,1
    80003636:	00000097          	auipc	ra,0x0
    8000363a:	eca080e7          	jalr	-310(ra) # 80003500 <install_trans>
  log.lh.n = 0;
    8000363e:	00015797          	auipc	a5,0x15
    80003642:	2e07a723          	sw	zero,750(a5) # 8001892c <log+0x2c>
  write_head(); // clear the log
    80003646:	00000097          	auipc	ra,0x0
    8000364a:	e50080e7          	jalr	-432(ra) # 80003496 <write_head>
}
    8000364e:	70a2                	ld	ra,40(sp)
    80003650:	7402                	ld	s0,32(sp)
    80003652:	64e2                	ld	s1,24(sp)
    80003654:	6942                	ld	s2,16(sp)
    80003656:	69a2                	ld	s3,8(sp)
    80003658:	6145                	add	sp,sp,48
    8000365a:	8082                	ret

000000008000365c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000365c:	1101                	add	sp,sp,-32
    8000365e:	ec06                	sd	ra,24(sp)
    80003660:	e822                	sd	s0,16(sp)
    80003662:	e426                	sd	s1,8(sp)
    80003664:	e04a                	sd	s2,0(sp)
    80003666:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003668:	00015517          	auipc	a0,0x15
    8000366c:	29850513          	add	a0,a0,664 # 80018900 <log>
    80003670:	00003097          	auipc	ra,0x3
    80003674:	d6c080e7          	jalr	-660(ra) # 800063dc <acquire>
  while(1){
    if(log.committing){
    80003678:	00015497          	auipc	s1,0x15
    8000367c:	28848493          	add	s1,s1,648 # 80018900 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003680:	4979                	li	s2,30
    80003682:	a039                	j	80003690 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003684:	85a6                	mv	a1,s1
    80003686:	8526                	mv	a0,s1
    80003688:	ffffe097          	auipc	ra,0xffffe
    8000368c:	f76080e7          	jalr	-138(ra) # 800015fe <sleep>
    if(log.committing){
    80003690:	50dc                	lw	a5,36(s1)
    80003692:	fbed                	bnez	a5,80003684 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003694:	5098                	lw	a4,32(s1)
    80003696:	2705                	addw	a4,a4,1
    80003698:	0027179b          	sllw	a5,a4,0x2
    8000369c:	9fb9                	addw	a5,a5,a4
    8000369e:	0017979b          	sllw	a5,a5,0x1
    800036a2:	54d4                	lw	a3,44(s1)
    800036a4:	9fb5                	addw	a5,a5,a3
    800036a6:	00f95963          	bge	s2,a5,800036b8 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036aa:	85a6                	mv	a1,s1
    800036ac:	8526                	mv	a0,s1
    800036ae:	ffffe097          	auipc	ra,0xffffe
    800036b2:	f50080e7          	jalr	-176(ra) # 800015fe <sleep>
    800036b6:	bfe9                	j	80003690 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036b8:	00015517          	auipc	a0,0x15
    800036bc:	24850513          	add	a0,a0,584 # 80018900 <log>
    800036c0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800036c2:	00003097          	auipc	ra,0x3
    800036c6:	dce080e7          	jalr	-562(ra) # 80006490 <release>
      break;
    }
  }
}
    800036ca:	60e2                	ld	ra,24(sp)
    800036cc:	6442                	ld	s0,16(sp)
    800036ce:	64a2                	ld	s1,8(sp)
    800036d0:	6902                	ld	s2,0(sp)
    800036d2:	6105                	add	sp,sp,32
    800036d4:	8082                	ret

00000000800036d6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036d6:	7139                	add	sp,sp,-64
    800036d8:	fc06                	sd	ra,56(sp)
    800036da:	f822                	sd	s0,48(sp)
    800036dc:	f426                	sd	s1,40(sp)
    800036de:	f04a                	sd	s2,32(sp)
    800036e0:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036e2:	00015497          	auipc	s1,0x15
    800036e6:	21e48493          	add	s1,s1,542 # 80018900 <log>
    800036ea:	8526                	mv	a0,s1
    800036ec:	00003097          	auipc	ra,0x3
    800036f0:	cf0080e7          	jalr	-784(ra) # 800063dc <acquire>
  log.outstanding -= 1;
    800036f4:	509c                	lw	a5,32(s1)
    800036f6:	37fd                	addw	a5,a5,-1
    800036f8:	0007891b          	sext.w	s2,a5
    800036fc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036fe:	50dc                	lw	a5,36(s1)
    80003700:	e7b9                	bnez	a5,8000374e <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003702:	06091163          	bnez	s2,80003764 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003706:	00015497          	auipc	s1,0x15
    8000370a:	1fa48493          	add	s1,s1,506 # 80018900 <log>
    8000370e:	4785                	li	a5,1
    80003710:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003712:	8526                	mv	a0,s1
    80003714:	00003097          	auipc	ra,0x3
    80003718:	d7c080e7          	jalr	-644(ra) # 80006490 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000371c:	54dc                	lw	a5,44(s1)
    8000371e:	06f04763          	bgtz	a5,8000378c <end_op+0xb6>
    acquire(&log.lock);
    80003722:	00015497          	auipc	s1,0x15
    80003726:	1de48493          	add	s1,s1,478 # 80018900 <log>
    8000372a:	8526                	mv	a0,s1
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	cb0080e7          	jalr	-848(ra) # 800063dc <acquire>
    log.committing = 0;
    80003734:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003738:	8526                	mv	a0,s1
    8000373a:	ffffe097          	auipc	ra,0xffffe
    8000373e:	f28080e7          	jalr	-216(ra) # 80001662 <wakeup>
    release(&log.lock);
    80003742:	8526                	mv	a0,s1
    80003744:	00003097          	auipc	ra,0x3
    80003748:	d4c080e7          	jalr	-692(ra) # 80006490 <release>
}
    8000374c:	a815                	j	80003780 <end_op+0xaa>
    8000374e:	ec4e                	sd	s3,24(sp)
    80003750:	e852                	sd	s4,16(sp)
    80003752:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003754:	00005517          	auipc	a0,0x5
    80003758:	da450513          	add	a0,a0,-604 # 800084f8 <etext+0x4f8>
    8000375c:	00002097          	auipc	ra,0x2
    80003760:	706080e7          	jalr	1798(ra) # 80005e62 <panic>
    wakeup(&log);
    80003764:	00015497          	auipc	s1,0x15
    80003768:	19c48493          	add	s1,s1,412 # 80018900 <log>
    8000376c:	8526                	mv	a0,s1
    8000376e:	ffffe097          	auipc	ra,0xffffe
    80003772:	ef4080e7          	jalr	-268(ra) # 80001662 <wakeup>
  release(&log.lock);
    80003776:	8526                	mv	a0,s1
    80003778:	00003097          	auipc	ra,0x3
    8000377c:	d18080e7          	jalr	-744(ra) # 80006490 <release>
}
    80003780:	70e2                	ld	ra,56(sp)
    80003782:	7442                	ld	s0,48(sp)
    80003784:	74a2                	ld	s1,40(sp)
    80003786:	7902                	ld	s2,32(sp)
    80003788:	6121                	add	sp,sp,64
    8000378a:	8082                	ret
    8000378c:	ec4e                	sd	s3,24(sp)
    8000378e:	e852                	sd	s4,16(sp)
    80003790:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003792:	00015a97          	auipc	s5,0x15
    80003796:	19ea8a93          	add	s5,s5,414 # 80018930 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000379a:	00015a17          	auipc	s4,0x15
    8000379e:	166a0a13          	add	s4,s4,358 # 80018900 <log>
    800037a2:	018a2583          	lw	a1,24(s4)
    800037a6:	012585bb          	addw	a1,a1,s2
    800037aa:	2585                	addw	a1,a1,1
    800037ac:	028a2503          	lw	a0,40(s4)
    800037b0:	fffff097          	auipc	ra,0xfffff
    800037b4:	caa080e7          	jalr	-854(ra) # 8000245a <bread>
    800037b8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037ba:	000aa583          	lw	a1,0(s5)
    800037be:	028a2503          	lw	a0,40(s4)
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	c98080e7          	jalr	-872(ra) # 8000245a <bread>
    800037ca:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037cc:	40000613          	li	a2,1024
    800037d0:	05850593          	add	a1,a0,88
    800037d4:	05848513          	add	a0,s1,88
    800037d8:	ffffd097          	auipc	ra,0xffffd
    800037dc:	a48080e7          	jalr	-1464(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    800037e0:	8526                	mv	a0,s1
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	d6a080e7          	jalr	-662(ra) # 8000254c <bwrite>
    brelse(from);
    800037ea:	854e                	mv	a0,s3
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	d9e080e7          	jalr	-610(ra) # 8000258a <brelse>
    brelse(to);
    800037f4:	8526                	mv	a0,s1
    800037f6:	fffff097          	auipc	ra,0xfffff
    800037fa:	d94080e7          	jalr	-620(ra) # 8000258a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037fe:	2905                	addw	s2,s2,1
    80003800:	0a91                	add	s5,s5,4
    80003802:	02ca2783          	lw	a5,44(s4)
    80003806:	f8f94ee3          	blt	s2,a5,800037a2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	c8c080e7          	jalr	-884(ra) # 80003496 <write_head>
    install_trans(0); // Now install writes to home locations
    80003812:	4501                	li	a0,0
    80003814:	00000097          	auipc	ra,0x0
    80003818:	cec080e7          	jalr	-788(ra) # 80003500 <install_trans>
    log.lh.n = 0;
    8000381c:	00015797          	auipc	a5,0x15
    80003820:	1007a823          	sw	zero,272(a5) # 8001892c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003824:	00000097          	auipc	ra,0x0
    80003828:	c72080e7          	jalr	-910(ra) # 80003496 <write_head>
    8000382c:	69e2                	ld	s3,24(sp)
    8000382e:	6a42                	ld	s4,16(sp)
    80003830:	6aa2                	ld	s5,8(sp)
    80003832:	bdc5                	j	80003722 <end_op+0x4c>

0000000080003834 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003834:	1101                	add	sp,sp,-32
    80003836:	ec06                	sd	ra,24(sp)
    80003838:	e822                	sd	s0,16(sp)
    8000383a:	e426                	sd	s1,8(sp)
    8000383c:	e04a                	sd	s2,0(sp)
    8000383e:	1000                	add	s0,sp,32
    80003840:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003842:	00015917          	auipc	s2,0x15
    80003846:	0be90913          	add	s2,s2,190 # 80018900 <log>
    8000384a:	854a                	mv	a0,s2
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	b90080e7          	jalr	-1136(ra) # 800063dc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003854:	02c92603          	lw	a2,44(s2)
    80003858:	47f5                	li	a5,29
    8000385a:	06c7c563          	blt	a5,a2,800038c4 <log_write+0x90>
    8000385e:	00015797          	auipc	a5,0x15
    80003862:	0be7a783          	lw	a5,190(a5) # 8001891c <log+0x1c>
    80003866:	37fd                	addw	a5,a5,-1
    80003868:	04f65e63          	bge	a2,a5,800038c4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000386c:	00015797          	auipc	a5,0x15
    80003870:	0b47a783          	lw	a5,180(a5) # 80018920 <log+0x20>
    80003874:	06f05063          	blez	a5,800038d4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003878:	4781                	li	a5,0
    8000387a:	06c05563          	blez	a2,800038e4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000387e:	44cc                	lw	a1,12(s1)
    80003880:	00015717          	auipc	a4,0x15
    80003884:	0b070713          	add	a4,a4,176 # 80018930 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003888:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000388a:	4314                	lw	a3,0(a4)
    8000388c:	04b68c63          	beq	a3,a1,800038e4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003890:	2785                	addw	a5,a5,1
    80003892:	0711                	add	a4,a4,4
    80003894:	fef61be3          	bne	a2,a5,8000388a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003898:	0621                	add	a2,a2,8
    8000389a:	060a                	sll	a2,a2,0x2
    8000389c:	00015797          	auipc	a5,0x15
    800038a0:	06478793          	add	a5,a5,100 # 80018900 <log>
    800038a4:	97b2                	add	a5,a5,a2
    800038a6:	44d8                	lw	a4,12(s1)
    800038a8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038aa:	8526                	mv	a0,s1
    800038ac:	fffff097          	auipc	ra,0xfffff
    800038b0:	d7a080e7          	jalr	-646(ra) # 80002626 <bpin>
    log.lh.n++;
    800038b4:	00015717          	auipc	a4,0x15
    800038b8:	04c70713          	add	a4,a4,76 # 80018900 <log>
    800038bc:	575c                	lw	a5,44(a4)
    800038be:	2785                	addw	a5,a5,1
    800038c0:	d75c                	sw	a5,44(a4)
    800038c2:	a82d                	j	800038fc <log_write+0xc8>
    panic("too big a transaction");
    800038c4:	00005517          	auipc	a0,0x5
    800038c8:	c4450513          	add	a0,a0,-956 # 80008508 <etext+0x508>
    800038cc:	00002097          	auipc	ra,0x2
    800038d0:	596080e7          	jalr	1430(ra) # 80005e62 <panic>
    panic("log_write outside of trans");
    800038d4:	00005517          	auipc	a0,0x5
    800038d8:	c4c50513          	add	a0,a0,-948 # 80008520 <etext+0x520>
    800038dc:	00002097          	auipc	ra,0x2
    800038e0:	586080e7          	jalr	1414(ra) # 80005e62 <panic>
  log.lh.block[i] = b->blockno;
    800038e4:	00878693          	add	a3,a5,8
    800038e8:	068a                	sll	a3,a3,0x2
    800038ea:	00015717          	auipc	a4,0x15
    800038ee:	01670713          	add	a4,a4,22 # 80018900 <log>
    800038f2:	9736                	add	a4,a4,a3
    800038f4:	44d4                	lw	a3,12(s1)
    800038f6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038f8:	faf609e3          	beq	a2,a5,800038aa <log_write+0x76>
  }
  release(&log.lock);
    800038fc:	00015517          	auipc	a0,0x15
    80003900:	00450513          	add	a0,a0,4 # 80018900 <log>
    80003904:	00003097          	auipc	ra,0x3
    80003908:	b8c080e7          	jalr	-1140(ra) # 80006490 <release>
}
    8000390c:	60e2                	ld	ra,24(sp)
    8000390e:	6442                	ld	s0,16(sp)
    80003910:	64a2                	ld	s1,8(sp)
    80003912:	6902                	ld	s2,0(sp)
    80003914:	6105                	add	sp,sp,32
    80003916:	8082                	ret

0000000080003918 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003918:	1101                	add	sp,sp,-32
    8000391a:	ec06                	sd	ra,24(sp)
    8000391c:	e822                	sd	s0,16(sp)
    8000391e:	e426                	sd	s1,8(sp)
    80003920:	e04a                	sd	s2,0(sp)
    80003922:	1000                	add	s0,sp,32
    80003924:	84aa                	mv	s1,a0
    80003926:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003928:	00005597          	auipc	a1,0x5
    8000392c:	c1858593          	add	a1,a1,-1000 # 80008540 <etext+0x540>
    80003930:	0521                	add	a0,a0,8
    80003932:	00003097          	auipc	ra,0x3
    80003936:	a1a080e7          	jalr	-1510(ra) # 8000634c <initlock>
  lk->name = name;
    8000393a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000393e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003942:	0204a423          	sw	zero,40(s1)
}
    80003946:	60e2                	ld	ra,24(sp)
    80003948:	6442                	ld	s0,16(sp)
    8000394a:	64a2                	ld	s1,8(sp)
    8000394c:	6902                	ld	s2,0(sp)
    8000394e:	6105                	add	sp,sp,32
    80003950:	8082                	ret

0000000080003952 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003952:	1101                	add	sp,sp,-32
    80003954:	ec06                	sd	ra,24(sp)
    80003956:	e822                	sd	s0,16(sp)
    80003958:	e426                	sd	s1,8(sp)
    8000395a:	e04a                	sd	s2,0(sp)
    8000395c:	1000                	add	s0,sp,32
    8000395e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003960:	00850913          	add	s2,a0,8
    80003964:	854a                	mv	a0,s2
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	a76080e7          	jalr	-1418(ra) # 800063dc <acquire>
  while (lk->locked) {
    8000396e:	409c                	lw	a5,0(s1)
    80003970:	cb89                	beqz	a5,80003982 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003972:	85ca                	mv	a1,s2
    80003974:	8526                	mv	a0,s1
    80003976:	ffffe097          	auipc	ra,0xffffe
    8000397a:	c88080e7          	jalr	-888(ra) # 800015fe <sleep>
  while (lk->locked) {
    8000397e:	409c                	lw	a5,0(s1)
    80003980:	fbed                	bnez	a5,80003972 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003982:	4785                	li	a5,1
    80003984:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003986:	ffffd097          	auipc	ra,0xffffd
    8000398a:	5ca080e7          	jalr	1482(ra) # 80000f50 <myproc>
    8000398e:	591c                	lw	a5,48(a0)
    80003990:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003992:	854a                	mv	a0,s2
    80003994:	00003097          	auipc	ra,0x3
    80003998:	afc080e7          	jalr	-1284(ra) # 80006490 <release>
}
    8000399c:	60e2                	ld	ra,24(sp)
    8000399e:	6442                	ld	s0,16(sp)
    800039a0:	64a2                	ld	s1,8(sp)
    800039a2:	6902                	ld	s2,0(sp)
    800039a4:	6105                	add	sp,sp,32
    800039a6:	8082                	ret

00000000800039a8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039a8:	1101                	add	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	e04a                	sd	s2,0(sp)
    800039b2:	1000                	add	s0,sp,32
    800039b4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039b6:	00850913          	add	s2,a0,8
    800039ba:	854a                	mv	a0,s2
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	a20080e7          	jalr	-1504(ra) # 800063dc <acquire>
  lk->locked = 0;
    800039c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039c8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039cc:	8526                	mv	a0,s1
    800039ce:	ffffe097          	auipc	ra,0xffffe
    800039d2:	c94080e7          	jalr	-876(ra) # 80001662 <wakeup>
  release(&lk->lk);
    800039d6:	854a                	mv	a0,s2
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	ab8080e7          	jalr	-1352(ra) # 80006490 <release>
}
    800039e0:	60e2                	ld	ra,24(sp)
    800039e2:	6442                	ld	s0,16(sp)
    800039e4:	64a2                	ld	s1,8(sp)
    800039e6:	6902                	ld	s2,0(sp)
    800039e8:	6105                	add	sp,sp,32
    800039ea:	8082                	ret

00000000800039ec <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039ec:	7179                	add	sp,sp,-48
    800039ee:	f406                	sd	ra,40(sp)
    800039f0:	f022                	sd	s0,32(sp)
    800039f2:	ec26                	sd	s1,24(sp)
    800039f4:	e84a                	sd	s2,16(sp)
    800039f6:	1800                	add	s0,sp,48
    800039f8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039fa:	00850913          	add	s2,a0,8
    800039fe:	854a                	mv	a0,s2
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	9dc080e7          	jalr	-1572(ra) # 800063dc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a08:	409c                	lw	a5,0(s1)
    80003a0a:	ef91                	bnez	a5,80003a26 <holdingsleep+0x3a>
    80003a0c:	4481                	li	s1,0
  release(&lk->lk);
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	a80080e7          	jalr	-1408(ra) # 80006490 <release>
  return r;
}
    80003a18:	8526                	mv	a0,s1
    80003a1a:	70a2                	ld	ra,40(sp)
    80003a1c:	7402                	ld	s0,32(sp)
    80003a1e:	64e2                	ld	s1,24(sp)
    80003a20:	6942                	ld	s2,16(sp)
    80003a22:	6145                	add	sp,sp,48
    80003a24:	8082                	ret
    80003a26:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a28:	0284a983          	lw	s3,40(s1)
    80003a2c:	ffffd097          	auipc	ra,0xffffd
    80003a30:	524080e7          	jalr	1316(ra) # 80000f50 <myproc>
    80003a34:	5904                	lw	s1,48(a0)
    80003a36:	413484b3          	sub	s1,s1,s3
    80003a3a:	0014b493          	seqz	s1,s1
    80003a3e:	69a2                	ld	s3,8(sp)
    80003a40:	b7f9                	j	80003a0e <holdingsleep+0x22>

0000000080003a42 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a42:	1141                	add	sp,sp,-16
    80003a44:	e406                	sd	ra,8(sp)
    80003a46:	e022                	sd	s0,0(sp)
    80003a48:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a4a:	00005597          	auipc	a1,0x5
    80003a4e:	b0658593          	add	a1,a1,-1274 # 80008550 <etext+0x550>
    80003a52:	00015517          	auipc	a0,0x15
    80003a56:	ff650513          	add	a0,a0,-10 # 80018a48 <ftable>
    80003a5a:	00003097          	auipc	ra,0x3
    80003a5e:	8f2080e7          	jalr	-1806(ra) # 8000634c <initlock>
}
    80003a62:	60a2                	ld	ra,8(sp)
    80003a64:	6402                	ld	s0,0(sp)
    80003a66:	0141                	add	sp,sp,16
    80003a68:	8082                	ret

0000000080003a6a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a6a:	1101                	add	sp,sp,-32
    80003a6c:	ec06                	sd	ra,24(sp)
    80003a6e:	e822                	sd	s0,16(sp)
    80003a70:	e426                	sd	s1,8(sp)
    80003a72:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a74:	00015517          	auipc	a0,0x15
    80003a78:	fd450513          	add	a0,a0,-44 # 80018a48 <ftable>
    80003a7c:	00003097          	auipc	ra,0x3
    80003a80:	960080e7          	jalr	-1696(ra) # 800063dc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a84:	00015497          	auipc	s1,0x15
    80003a88:	fdc48493          	add	s1,s1,-36 # 80018a60 <ftable+0x18>
    80003a8c:	00016717          	auipc	a4,0x16
    80003a90:	f7470713          	add	a4,a4,-140 # 80019a00 <disk>
    if(f->ref == 0){
    80003a94:	40dc                	lw	a5,4(s1)
    80003a96:	cf99                	beqz	a5,80003ab4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a98:	02848493          	add	s1,s1,40
    80003a9c:	fee49ce3          	bne	s1,a4,80003a94 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003aa0:	00015517          	auipc	a0,0x15
    80003aa4:	fa850513          	add	a0,a0,-88 # 80018a48 <ftable>
    80003aa8:	00003097          	auipc	ra,0x3
    80003aac:	9e8080e7          	jalr	-1560(ra) # 80006490 <release>
  return 0;
    80003ab0:	4481                	li	s1,0
    80003ab2:	a819                	j	80003ac8 <filealloc+0x5e>
      f->ref = 1;
    80003ab4:	4785                	li	a5,1
    80003ab6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ab8:	00015517          	auipc	a0,0x15
    80003abc:	f9050513          	add	a0,a0,-112 # 80018a48 <ftable>
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	9d0080e7          	jalr	-1584(ra) # 80006490 <release>
}
    80003ac8:	8526                	mv	a0,s1
    80003aca:	60e2                	ld	ra,24(sp)
    80003acc:	6442                	ld	s0,16(sp)
    80003ace:	64a2                	ld	s1,8(sp)
    80003ad0:	6105                	add	sp,sp,32
    80003ad2:	8082                	ret

0000000080003ad4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ad4:	1101                	add	sp,sp,-32
    80003ad6:	ec06                	sd	ra,24(sp)
    80003ad8:	e822                	sd	s0,16(sp)
    80003ada:	e426                	sd	s1,8(sp)
    80003adc:	1000                	add	s0,sp,32
    80003ade:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ae0:	00015517          	auipc	a0,0x15
    80003ae4:	f6850513          	add	a0,a0,-152 # 80018a48 <ftable>
    80003ae8:	00003097          	auipc	ra,0x3
    80003aec:	8f4080e7          	jalr	-1804(ra) # 800063dc <acquire>
  if(f->ref < 1)
    80003af0:	40dc                	lw	a5,4(s1)
    80003af2:	02f05263          	blez	a5,80003b16 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003af6:	2785                	addw	a5,a5,1
    80003af8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003afa:	00015517          	auipc	a0,0x15
    80003afe:	f4e50513          	add	a0,a0,-178 # 80018a48 <ftable>
    80003b02:	00003097          	auipc	ra,0x3
    80003b06:	98e080e7          	jalr	-1650(ra) # 80006490 <release>
  return f;
}
    80003b0a:	8526                	mv	a0,s1
    80003b0c:	60e2                	ld	ra,24(sp)
    80003b0e:	6442                	ld	s0,16(sp)
    80003b10:	64a2                	ld	s1,8(sp)
    80003b12:	6105                	add	sp,sp,32
    80003b14:	8082                	ret
    panic("filedup");
    80003b16:	00005517          	auipc	a0,0x5
    80003b1a:	a4250513          	add	a0,a0,-1470 # 80008558 <etext+0x558>
    80003b1e:	00002097          	auipc	ra,0x2
    80003b22:	344080e7          	jalr	836(ra) # 80005e62 <panic>

0000000080003b26 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b26:	7139                	add	sp,sp,-64
    80003b28:	fc06                	sd	ra,56(sp)
    80003b2a:	f822                	sd	s0,48(sp)
    80003b2c:	f426                	sd	s1,40(sp)
    80003b2e:	0080                	add	s0,sp,64
    80003b30:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b32:	00015517          	auipc	a0,0x15
    80003b36:	f1650513          	add	a0,a0,-234 # 80018a48 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	8a2080e7          	jalr	-1886(ra) # 800063dc <acquire>
  if(f->ref < 1)
    80003b42:	40dc                	lw	a5,4(s1)
    80003b44:	04f05c63          	blez	a5,80003b9c <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003b48:	37fd                	addw	a5,a5,-1
    80003b4a:	0007871b          	sext.w	a4,a5
    80003b4e:	c0dc                	sw	a5,4(s1)
    80003b50:	06e04263          	bgtz	a4,80003bb4 <fileclose+0x8e>
    80003b54:	f04a                	sd	s2,32(sp)
    80003b56:	ec4e                	sd	s3,24(sp)
    80003b58:	e852                	sd	s4,16(sp)
    80003b5a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b5c:	0004a903          	lw	s2,0(s1)
    80003b60:	0094ca83          	lbu	s5,9(s1)
    80003b64:	0104ba03          	ld	s4,16(s1)
    80003b68:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b6c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b70:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b74:	00015517          	auipc	a0,0x15
    80003b78:	ed450513          	add	a0,a0,-300 # 80018a48 <ftable>
    80003b7c:	00003097          	auipc	ra,0x3
    80003b80:	914080e7          	jalr	-1772(ra) # 80006490 <release>

  if(ff.type == FD_PIPE){
    80003b84:	4785                	li	a5,1
    80003b86:	04f90463          	beq	s2,a5,80003bce <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b8a:	3979                	addw	s2,s2,-2
    80003b8c:	4785                	li	a5,1
    80003b8e:	0527fb63          	bgeu	a5,s2,80003be4 <fileclose+0xbe>
    80003b92:	7902                	ld	s2,32(sp)
    80003b94:	69e2                	ld	s3,24(sp)
    80003b96:	6a42                	ld	s4,16(sp)
    80003b98:	6aa2                	ld	s5,8(sp)
    80003b9a:	a02d                	j	80003bc4 <fileclose+0x9e>
    80003b9c:	f04a                	sd	s2,32(sp)
    80003b9e:	ec4e                	sd	s3,24(sp)
    80003ba0:	e852                	sd	s4,16(sp)
    80003ba2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003ba4:	00005517          	auipc	a0,0x5
    80003ba8:	9bc50513          	add	a0,a0,-1604 # 80008560 <etext+0x560>
    80003bac:	00002097          	auipc	ra,0x2
    80003bb0:	2b6080e7          	jalr	694(ra) # 80005e62 <panic>
    release(&ftable.lock);
    80003bb4:	00015517          	auipc	a0,0x15
    80003bb8:	e9450513          	add	a0,a0,-364 # 80018a48 <ftable>
    80003bbc:	00003097          	auipc	ra,0x3
    80003bc0:	8d4080e7          	jalr	-1836(ra) # 80006490 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003bc4:	70e2                	ld	ra,56(sp)
    80003bc6:	7442                	ld	s0,48(sp)
    80003bc8:	74a2                	ld	s1,40(sp)
    80003bca:	6121                	add	sp,sp,64
    80003bcc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bce:	85d6                	mv	a1,s5
    80003bd0:	8552                	mv	a0,s4
    80003bd2:	00000097          	auipc	ra,0x0
    80003bd6:	3a2080e7          	jalr	930(ra) # 80003f74 <pipeclose>
    80003bda:	7902                	ld	s2,32(sp)
    80003bdc:	69e2                	ld	s3,24(sp)
    80003bde:	6a42                	ld	s4,16(sp)
    80003be0:	6aa2                	ld	s5,8(sp)
    80003be2:	b7cd                	j	80003bc4 <fileclose+0x9e>
    begin_op();
    80003be4:	00000097          	auipc	ra,0x0
    80003be8:	a78080e7          	jalr	-1416(ra) # 8000365c <begin_op>
    iput(ff.ip);
    80003bec:	854e                	mv	a0,s3
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	25e080e7          	jalr	606(ra) # 80002e4c <iput>
    end_op();
    80003bf6:	00000097          	auipc	ra,0x0
    80003bfa:	ae0080e7          	jalr	-1312(ra) # 800036d6 <end_op>
    80003bfe:	7902                	ld	s2,32(sp)
    80003c00:	69e2                	ld	s3,24(sp)
    80003c02:	6a42                	ld	s4,16(sp)
    80003c04:	6aa2                	ld	s5,8(sp)
    80003c06:	bf7d                	j	80003bc4 <fileclose+0x9e>

0000000080003c08 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c08:	715d                	add	sp,sp,-80
    80003c0a:	e486                	sd	ra,72(sp)
    80003c0c:	e0a2                	sd	s0,64(sp)
    80003c0e:	fc26                	sd	s1,56(sp)
    80003c10:	f44e                	sd	s3,40(sp)
    80003c12:	0880                	add	s0,sp,80
    80003c14:	84aa                	mv	s1,a0
    80003c16:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c18:	ffffd097          	auipc	ra,0xffffd
    80003c1c:	338080e7          	jalr	824(ra) # 80000f50 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c20:	409c                	lw	a5,0(s1)
    80003c22:	37f9                	addw	a5,a5,-2
    80003c24:	4705                	li	a4,1
    80003c26:	04f76863          	bltu	a4,a5,80003c76 <filestat+0x6e>
    80003c2a:	f84a                	sd	s2,48(sp)
    80003c2c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c2e:	6c88                	ld	a0,24(s1)
    80003c30:	fffff097          	auipc	ra,0xfffff
    80003c34:	05e080e7          	jalr	94(ra) # 80002c8e <ilock>
    stati(f->ip, &st);
    80003c38:	fb840593          	add	a1,s0,-72
    80003c3c:	6c88                	ld	a0,24(s1)
    80003c3e:	fffff097          	auipc	ra,0xfffff
    80003c42:	2de080e7          	jalr	734(ra) # 80002f1c <stati>
    iunlock(f->ip);
    80003c46:	6c88                	ld	a0,24(s1)
    80003c48:	fffff097          	auipc	ra,0xfffff
    80003c4c:	10c080e7          	jalr	268(ra) # 80002d54 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c50:	46e1                	li	a3,24
    80003c52:	fb840613          	add	a2,s0,-72
    80003c56:	85ce                	mv	a1,s3
    80003c58:	05093503          	ld	a0,80(s2)
    80003c5c:	ffffd097          	auipc	ra,0xffffd
    80003c60:	f3a080e7          	jalr	-198(ra) # 80000b96 <copyout>
    80003c64:	41f5551b          	sraw	a0,a0,0x1f
    80003c68:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c6a:	60a6                	ld	ra,72(sp)
    80003c6c:	6406                	ld	s0,64(sp)
    80003c6e:	74e2                	ld	s1,56(sp)
    80003c70:	79a2                	ld	s3,40(sp)
    80003c72:	6161                	add	sp,sp,80
    80003c74:	8082                	ret
  return -1;
    80003c76:	557d                	li	a0,-1
    80003c78:	bfcd                	j	80003c6a <filestat+0x62>

0000000080003c7a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c7a:	7179                	add	sp,sp,-48
    80003c7c:	f406                	sd	ra,40(sp)
    80003c7e:	f022                	sd	s0,32(sp)
    80003c80:	e84a                	sd	s2,16(sp)
    80003c82:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c84:	00854783          	lbu	a5,8(a0)
    80003c88:	cbc5                	beqz	a5,80003d38 <fileread+0xbe>
    80003c8a:	ec26                	sd	s1,24(sp)
    80003c8c:	e44e                	sd	s3,8(sp)
    80003c8e:	84aa                	mv	s1,a0
    80003c90:	89ae                	mv	s3,a1
    80003c92:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c94:	411c                	lw	a5,0(a0)
    80003c96:	4705                	li	a4,1
    80003c98:	04e78963          	beq	a5,a4,80003cea <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c9c:	470d                	li	a4,3
    80003c9e:	04e78f63          	beq	a5,a4,80003cfc <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ca2:	4709                	li	a4,2
    80003ca4:	08e79263          	bne	a5,a4,80003d28 <fileread+0xae>
    ilock(f->ip);
    80003ca8:	6d08                	ld	a0,24(a0)
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	fe4080e7          	jalr	-28(ra) # 80002c8e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cb2:	874a                	mv	a4,s2
    80003cb4:	5094                	lw	a3,32(s1)
    80003cb6:	864e                	mv	a2,s3
    80003cb8:	4585                	li	a1,1
    80003cba:	6c88                	ld	a0,24(s1)
    80003cbc:	fffff097          	auipc	ra,0xfffff
    80003cc0:	28a080e7          	jalr	650(ra) # 80002f46 <readi>
    80003cc4:	892a                	mv	s2,a0
    80003cc6:	00a05563          	blez	a0,80003cd0 <fileread+0x56>
      f->off += r;
    80003cca:	509c                	lw	a5,32(s1)
    80003ccc:	9fa9                	addw	a5,a5,a0
    80003cce:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cd0:	6c88                	ld	a0,24(s1)
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	082080e7          	jalr	130(ra) # 80002d54 <iunlock>
    80003cda:	64e2                	ld	s1,24(sp)
    80003cdc:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003cde:	854a                	mv	a0,s2
    80003ce0:	70a2                	ld	ra,40(sp)
    80003ce2:	7402                	ld	s0,32(sp)
    80003ce4:	6942                	ld	s2,16(sp)
    80003ce6:	6145                	add	sp,sp,48
    80003ce8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cea:	6908                	ld	a0,16(a0)
    80003cec:	00000097          	auipc	ra,0x0
    80003cf0:	400080e7          	jalr	1024(ra) # 800040ec <piperead>
    80003cf4:	892a                	mv	s2,a0
    80003cf6:	64e2                	ld	s1,24(sp)
    80003cf8:	69a2                	ld	s3,8(sp)
    80003cfa:	b7d5                	j	80003cde <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cfc:	02451783          	lh	a5,36(a0)
    80003d00:	03079693          	sll	a3,a5,0x30
    80003d04:	92c1                	srl	a3,a3,0x30
    80003d06:	4725                	li	a4,9
    80003d08:	02d76a63          	bltu	a4,a3,80003d3c <fileread+0xc2>
    80003d0c:	0792                	sll	a5,a5,0x4
    80003d0e:	00015717          	auipc	a4,0x15
    80003d12:	c9a70713          	add	a4,a4,-870 # 800189a8 <devsw>
    80003d16:	97ba                	add	a5,a5,a4
    80003d18:	639c                	ld	a5,0(a5)
    80003d1a:	c78d                	beqz	a5,80003d44 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d1c:	4505                	li	a0,1
    80003d1e:	9782                	jalr	a5
    80003d20:	892a                	mv	s2,a0
    80003d22:	64e2                	ld	s1,24(sp)
    80003d24:	69a2                	ld	s3,8(sp)
    80003d26:	bf65                	j	80003cde <fileread+0x64>
    panic("fileread");
    80003d28:	00005517          	auipc	a0,0x5
    80003d2c:	84850513          	add	a0,a0,-1976 # 80008570 <etext+0x570>
    80003d30:	00002097          	auipc	ra,0x2
    80003d34:	132080e7          	jalr	306(ra) # 80005e62 <panic>
    return -1;
    80003d38:	597d                	li	s2,-1
    80003d3a:	b755                	j	80003cde <fileread+0x64>
      return -1;
    80003d3c:	597d                	li	s2,-1
    80003d3e:	64e2                	ld	s1,24(sp)
    80003d40:	69a2                	ld	s3,8(sp)
    80003d42:	bf71                	j	80003cde <fileread+0x64>
    80003d44:	597d                	li	s2,-1
    80003d46:	64e2                	ld	s1,24(sp)
    80003d48:	69a2                	ld	s3,8(sp)
    80003d4a:	bf51                	j	80003cde <fileread+0x64>

0000000080003d4c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003d4c:	00954783          	lbu	a5,9(a0)
    80003d50:	12078963          	beqz	a5,80003e82 <filewrite+0x136>
{
    80003d54:	715d                	add	sp,sp,-80
    80003d56:	e486                	sd	ra,72(sp)
    80003d58:	e0a2                	sd	s0,64(sp)
    80003d5a:	f84a                	sd	s2,48(sp)
    80003d5c:	f052                	sd	s4,32(sp)
    80003d5e:	e85a                	sd	s6,16(sp)
    80003d60:	0880                	add	s0,sp,80
    80003d62:	892a                	mv	s2,a0
    80003d64:	8b2e                	mv	s6,a1
    80003d66:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d68:	411c                	lw	a5,0(a0)
    80003d6a:	4705                	li	a4,1
    80003d6c:	02e78763          	beq	a5,a4,80003d9a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d70:	470d                	li	a4,3
    80003d72:	02e78a63          	beq	a5,a4,80003da6 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d76:	4709                	li	a4,2
    80003d78:	0ee79863          	bne	a5,a4,80003e68 <filewrite+0x11c>
    80003d7c:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d7e:	0cc05463          	blez	a2,80003e46 <filewrite+0xfa>
    80003d82:	fc26                	sd	s1,56(sp)
    80003d84:	ec56                	sd	s5,24(sp)
    80003d86:	e45e                	sd	s7,8(sp)
    80003d88:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d8a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d8c:	6b85                	lui	s7,0x1
    80003d8e:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d92:	6c05                	lui	s8,0x1
    80003d94:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d98:	a851                	j	80003e2c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d9a:	6908                	ld	a0,16(a0)
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	248080e7          	jalr	584(ra) # 80003fe4 <pipewrite>
    80003da4:	a85d                	j	80003e5a <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003da6:	02451783          	lh	a5,36(a0)
    80003daa:	03079693          	sll	a3,a5,0x30
    80003dae:	92c1                	srl	a3,a3,0x30
    80003db0:	4725                	li	a4,9
    80003db2:	0cd76a63          	bltu	a4,a3,80003e86 <filewrite+0x13a>
    80003db6:	0792                	sll	a5,a5,0x4
    80003db8:	00015717          	auipc	a4,0x15
    80003dbc:	bf070713          	add	a4,a4,-1040 # 800189a8 <devsw>
    80003dc0:	97ba                	add	a5,a5,a4
    80003dc2:	679c                	ld	a5,8(a5)
    80003dc4:	c3f9                	beqz	a5,80003e8a <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003dc6:	4505                	li	a0,1
    80003dc8:	9782                	jalr	a5
    80003dca:	a841                	j	80003e5a <filewrite+0x10e>
      if(n1 > max)
    80003dcc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003dd0:	00000097          	auipc	ra,0x0
    80003dd4:	88c080e7          	jalr	-1908(ra) # 8000365c <begin_op>
      ilock(f->ip);
    80003dd8:	01893503          	ld	a0,24(s2)
    80003ddc:	fffff097          	auipc	ra,0xfffff
    80003de0:	eb2080e7          	jalr	-334(ra) # 80002c8e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003de4:	8756                	mv	a4,s5
    80003de6:	02092683          	lw	a3,32(s2)
    80003dea:	01698633          	add	a2,s3,s6
    80003dee:	4585                	li	a1,1
    80003df0:	01893503          	ld	a0,24(s2)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	262080e7          	jalr	610(ra) # 80003056 <writei>
    80003dfc:	84aa                	mv	s1,a0
    80003dfe:	00a05763          	blez	a0,80003e0c <filewrite+0xc0>
        f->off += r;
    80003e02:	02092783          	lw	a5,32(s2)
    80003e06:	9fa9                	addw	a5,a5,a0
    80003e08:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e0c:	01893503          	ld	a0,24(s2)
    80003e10:	fffff097          	auipc	ra,0xfffff
    80003e14:	f44080e7          	jalr	-188(ra) # 80002d54 <iunlock>
      end_op();
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	8be080e7          	jalr	-1858(ra) # 800036d6 <end_op>

      if(r != n1){
    80003e20:	029a9563          	bne	s5,s1,80003e4a <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003e24:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e28:	0149da63          	bge	s3,s4,80003e3c <filewrite+0xf0>
      int n1 = n - i;
    80003e2c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003e30:	0004879b          	sext.w	a5,s1
    80003e34:	f8fbdce3          	bge	s7,a5,80003dcc <filewrite+0x80>
    80003e38:	84e2                	mv	s1,s8
    80003e3a:	bf49                	j	80003dcc <filewrite+0x80>
    80003e3c:	74e2                	ld	s1,56(sp)
    80003e3e:	6ae2                	ld	s5,24(sp)
    80003e40:	6ba2                	ld	s7,8(sp)
    80003e42:	6c02                	ld	s8,0(sp)
    80003e44:	a039                	j	80003e52 <filewrite+0x106>
    int i = 0;
    80003e46:	4981                	li	s3,0
    80003e48:	a029                	j	80003e52 <filewrite+0x106>
    80003e4a:	74e2                	ld	s1,56(sp)
    80003e4c:	6ae2                	ld	s5,24(sp)
    80003e4e:	6ba2                	ld	s7,8(sp)
    80003e50:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003e52:	033a1e63          	bne	s4,s3,80003e8e <filewrite+0x142>
    80003e56:	8552                	mv	a0,s4
    80003e58:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e5a:	60a6                	ld	ra,72(sp)
    80003e5c:	6406                	ld	s0,64(sp)
    80003e5e:	7942                	ld	s2,48(sp)
    80003e60:	7a02                	ld	s4,32(sp)
    80003e62:	6b42                	ld	s6,16(sp)
    80003e64:	6161                	add	sp,sp,80
    80003e66:	8082                	ret
    80003e68:	fc26                	sd	s1,56(sp)
    80003e6a:	f44e                	sd	s3,40(sp)
    80003e6c:	ec56                	sd	s5,24(sp)
    80003e6e:	e45e                	sd	s7,8(sp)
    80003e70:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e72:	00004517          	auipc	a0,0x4
    80003e76:	70e50513          	add	a0,a0,1806 # 80008580 <etext+0x580>
    80003e7a:	00002097          	auipc	ra,0x2
    80003e7e:	fe8080e7          	jalr	-24(ra) # 80005e62 <panic>
    return -1;
    80003e82:	557d                	li	a0,-1
}
    80003e84:	8082                	ret
      return -1;
    80003e86:	557d                	li	a0,-1
    80003e88:	bfc9                	j	80003e5a <filewrite+0x10e>
    80003e8a:	557d                	li	a0,-1
    80003e8c:	b7f9                	j	80003e5a <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e8e:	557d                	li	a0,-1
    80003e90:	79a2                	ld	s3,40(sp)
    80003e92:	b7e1                	j	80003e5a <filewrite+0x10e>

0000000080003e94 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e94:	7179                	add	sp,sp,-48
    80003e96:	f406                	sd	ra,40(sp)
    80003e98:	f022                	sd	s0,32(sp)
    80003e9a:	ec26                	sd	s1,24(sp)
    80003e9c:	e052                	sd	s4,0(sp)
    80003e9e:	1800                	add	s0,sp,48
    80003ea0:	84aa                	mv	s1,a0
    80003ea2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ea4:	0005b023          	sd	zero,0(a1)
    80003ea8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	bbe080e7          	jalr	-1090(ra) # 80003a6a <filealloc>
    80003eb4:	e088                	sd	a0,0(s1)
    80003eb6:	cd49                	beqz	a0,80003f50 <pipealloc+0xbc>
    80003eb8:	00000097          	auipc	ra,0x0
    80003ebc:	bb2080e7          	jalr	-1102(ra) # 80003a6a <filealloc>
    80003ec0:	00aa3023          	sd	a0,0(s4)
    80003ec4:	c141                	beqz	a0,80003f44 <pipealloc+0xb0>
    80003ec6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ec8:	ffffc097          	auipc	ra,0xffffc
    80003ecc:	252080e7          	jalr	594(ra) # 8000011a <kalloc>
    80003ed0:	892a                	mv	s2,a0
    80003ed2:	c13d                	beqz	a0,80003f38 <pipealloc+0xa4>
    80003ed4:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003ed6:	4985                	li	s3,1
    80003ed8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003edc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ee0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ee4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ee8:	00004597          	auipc	a1,0x4
    80003eec:	6a858593          	add	a1,a1,1704 # 80008590 <etext+0x590>
    80003ef0:	00002097          	auipc	ra,0x2
    80003ef4:	45c080e7          	jalr	1116(ra) # 8000634c <initlock>
  (*f0)->type = FD_PIPE;
    80003ef8:	609c                	ld	a5,0(s1)
    80003efa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003efe:	609c                	ld	a5,0(s1)
    80003f00:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f04:	609c                	ld	a5,0(s1)
    80003f06:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f0a:	609c                	ld	a5,0(s1)
    80003f0c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f10:	000a3783          	ld	a5,0(s4)
    80003f14:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f18:	000a3783          	ld	a5,0(s4)
    80003f1c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f20:	000a3783          	ld	a5,0(s4)
    80003f24:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f28:	000a3783          	ld	a5,0(s4)
    80003f2c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f30:	4501                	li	a0,0
    80003f32:	6942                	ld	s2,16(sp)
    80003f34:	69a2                	ld	s3,8(sp)
    80003f36:	a03d                	j	80003f64 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f38:	6088                	ld	a0,0(s1)
    80003f3a:	c119                	beqz	a0,80003f40 <pipealloc+0xac>
    80003f3c:	6942                	ld	s2,16(sp)
    80003f3e:	a029                	j	80003f48 <pipealloc+0xb4>
    80003f40:	6942                	ld	s2,16(sp)
    80003f42:	a039                	j	80003f50 <pipealloc+0xbc>
    80003f44:	6088                	ld	a0,0(s1)
    80003f46:	c50d                	beqz	a0,80003f70 <pipealloc+0xdc>
    fileclose(*f0);
    80003f48:	00000097          	auipc	ra,0x0
    80003f4c:	bde080e7          	jalr	-1058(ra) # 80003b26 <fileclose>
  if(*f1)
    80003f50:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f54:	557d                	li	a0,-1
  if(*f1)
    80003f56:	c799                	beqz	a5,80003f64 <pipealloc+0xd0>
    fileclose(*f1);
    80003f58:	853e                	mv	a0,a5
    80003f5a:	00000097          	auipc	ra,0x0
    80003f5e:	bcc080e7          	jalr	-1076(ra) # 80003b26 <fileclose>
  return -1;
    80003f62:	557d                	li	a0,-1
}
    80003f64:	70a2                	ld	ra,40(sp)
    80003f66:	7402                	ld	s0,32(sp)
    80003f68:	64e2                	ld	s1,24(sp)
    80003f6a:	6a02                	ld	s4,0(sp)
    80003f6c:	6145                	add	sp,sp,48
    80003f6e:	8082                	ret
  return -1;
    80003f70:	557d                	li	a0,-1
    80003f72:	bfcd                	j	80003f64 <pipealloc+0xd0>

0000000080003f74 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f74:	1101                	add	sp,sp,-32
    80003f76:	ec06                	sd	ra,24(sp)
    80003f78:	e822                	sd	s0,16(sp)
    80003f7a:	e426                	sd	s1,8(sp)
    80003f7c:	e04a                	sd	s2,0(sp)
    80003f7e:	1000                	add	s0,sp,32
    80003f80:	84aa                	mv	s1,a0
    80003f82:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f84:	00002097          	auipc	ra,0x2
    80003f88:	458080e7          	jalr	1112(ra) # 800063dc <acquire>
  if(writable){
    80003f8c:	02090d63          	beqz	s2,80003fc6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f90:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f94:	21848513          	add	a0,s1,536
    80003f98:	ffffd097          	auipc	ra,0xffffd
    80003f9c:	6ca080e7          	jalr	1738(ra) # 80001662 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fa0:	2204b783          	ld	a5,544(s1)
    80003fa4:	eb95                	bnez	a5,80003fd8 <pipeclose+0x64>
    release(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	00002097          	auipc	ra,0x2
    80003fac:	4e8080e7          	jalr	1256(ra) # 80006490 <release>
    kfree((char*)pi);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	ffffc097          	auipc	ra,0xffffc
    80003fb6:	06a080e7          	jalr	106(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fba:	60e2                	ld	ra,24(sp)
    80003fbc:	6442                	ld	s0,16(sp)
    80003fbe:	64a2                	ld	s1,8(sp)
    80003fc0:	6902                	ld	s2,0(sp)
    80003fc2:	6105                	add	sp,sp,32
    80003fc4:	8082                	ret
    pi->readopen = 0;
    80003fc6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fca:	21c48513          	add	a0,s1,540
    80003fce:	ffffd097          	auipc	ra,0xffffd
    80003fd2:	694080e7          	jalr	1684(ra) # 80001662 <wakeup>
    80003fd6:	b7e9                	j	80003fa0 <pipeclose+0x2c>
    release(&pi->lock);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	00002097          	auipc	ra,0x2
    80003fde:	4b6080e7          	jalr	1206(ra) # 80006490 <release>
}
    80003fe2:	bfe1                	j	80003fba <pipeclose+0x46>

0000000080003fe4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fe4:	711d                	add	sp,sp,-96
    80003fe6:	ec86                	sd	ra,88(sp)
    80003fe8:	e8a2                	sd	s0,80(sp)
    80003fea:	e4a6                	sd	s1,72(sp)
    80003fec:	e0ca                	sd	s2,64(sp)
    80003fee:	fc4e                	sd	s3,56(sp)
    80003ff0:	f852                	sd	s4,48(sp)
    80003ff2:	f456                	sd	s5,40(sp)
    80003ff4:	1080                	add	s0,sp,96
    80003ff6:	84aa                	mv	s1,a0
    80003ff8:	8aae                	mv	s5,a1
    80003ffa:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	f54080e7          	jalr	-172(ra) # 80000f50 <myproc>
    80004004:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004006:	8526                	mv	a0,s1
    80004008:	00002097          	auipc	ra,0x2
    8000400c:	3d4080e7          	jalr	980(ra) # 800063dc <acquire>
  while(i < n){
    80004010:	0d405863          	blez	s4,800040e0 <pipewrite+0xfc>
    80004014:	f05a                	sd	s6,32(sp)
    80004016:	ec5e                	sd	s7,24(sp)
    80004018:	e862                	sd	s8,16(sp)
  int i = 0;
    8000401a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000401c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000401e:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004022:	21c48b93          	add	s7,s1,540
    80004026:	a089                	j	80004068 <pipewrite+0x84>
      release(&pi->lock);
    80004028:	8526                	mv	a0,s1
    8000402a:	00002097          	auipc	ra,0x2
    8000402e:	466080e7          	jalr	1126(ra) # 80006490 <release>
      return -1;
    80004032:	597d                	li	s2,-1
    80004034:	7b02                	ld	s6,32(sp)
    80004036:	6be2                	ld	s7,24(sp)
    80004038:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000403a:	854a                	mv	a0,s2
    8000403c:	60e6                	ld	ra,88(sp)
    8000403e:	6446                	ld	s0,80(sp)
    80004040:	64a6                	ld	s1,72(sp)
    80004042:	6906                	ld	s2,64(sp)
    80004044:	79e2                	ld	s3,56(sp)
    80004046:	7a42                	ld	s4,48(sp)
    80004048:	7aa2                	ld	s5,40(sp)
    8000404a:	6125                	add	sp,sp,96
    8000404c:	8082                	ret
      wakeup(&pi->nread);
    8000404e:	8562                	mv	a0,s8
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	612080e7          	jalr	1554(ra) # 80001662 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004058:	85a6                	mv	a1,s1
    8000405a:	855e                	mv	a0,s7
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	5a2080e7          	jalr	1442(ra) # 800015fe <sleep>
  while(i < n){
    80004064:	05495f63          	bge	s2,s4,800040c2 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004068:	2204a783          	lw	a5,544(s1)
    8000406c:	dfd5                	beqz	a5,80004028 <pipewrite+0x44>
    8000406e:	854e                	mv	a0,s3
    80004070:	ffffe097          	auipc	ra,0xffffe
    80004074:	836080e7          	jalr	-1994(ra) # 800018a6 <killed>
    80004078:	f945                	bnez	a0,80004028 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000407a:	2184a783          	lw	a5,536(s1)
    8000407e:	21c4a703          	lw	a4,540(s1)
    80004082:	2007879b          	addw	a5,a5,512
    80004086:	fcf704e3          	beq	a4,a5,8000404e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000408a:	4685                	li	a3,1
    8000408c:	01590633          	add	a2,s2,s5
    80004090:	faf40593          	add	a1,s0,-81
    80004094:	0509b503          	ld	a0,80(s3)
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	bdc080e7          	jalr	-1060(ra) # 80000c74 <copyin>
    800040a0:	05650263          	beq	a0,s6,800040e4 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040a4:	21c4a783          	lw	a5,540(s1)
    800040a8:	0017871b          	addw	a4,a5,1
    800040ac:	20e4ae23          	sw	a4,540(s1)
    800040b0:	1ff7f793          	and	a5,a5,511
    800040b4:	97a6                	add	a5,a5,s1
    800040b6:	faf44703          	lbu	a4,-81(s0)
    800040ba:	00e78c23          	sb	a4,24(a5)
      i++;
    800040be:	2905                	addw	s2,s2,1
    800040c0:	b755                	j	80004064 <pipewrite+0x80>
    800040c2:	7b02                	ld	s6,32(sp)
    800040c4:	6be2                	ld	s7,24(sp)
    800040c6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800040c8:	21848513          	add	a0,s1,536
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	596080e7          	jalr	1430(ra) # 80001662 <wakeup>
  release(&pi->lock);
    800040d4:	8526                	mv	a0,s1
    800040d6:	00002097          	auipc	ra,0x2
    800040da:	3ba080e7          	jalr	954(ra) # 80006490 <release>
  return i;
    800040de:	bfb1                	j	8000403a <pipewrite+0x56>
  int i = 0;
    800040e0:	4901                	li	s2,0
    800040e2:	b7dd                	j	800040c8 <pipewrite+0xe4>
    800040e4:	7b02                	ld	s6,32(sp)
    800040e6:	6be2                	ld	s7,24(sp)
    800040e8:	6c42                	ld	s8,16(sp)
    800040ea:	bff9                	j	800040c8 <pipewrite+0xe4>

00000000800040ec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040ec:	715d                	add	sp,sp,-80
    800040ee:	e486                	sd	ra,72(sp)
    800040f0:	e0a2                	sd	s0,64(sp)
    800040f2:	fc26                	sd	s1,56(sp)
    800040f4:	f84a                	sd	s2,48(sp)
    800040f6:	f44e                	sd	s3,40(sp)
    800040f8:	f052                	sd	s4,32(sp)
    800040fa:	ec56                	sd	s5,24(sp)
    800040fc:	0880                	add	s0,sp,80
    800040fe:	84aa                	mv	s1,a0
    80004100:	892e                	mv	s2,a1
    80004102:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	e4c080e7          	jalr	-436(ra) # 80000f50 <myproc>
    8000410c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000410e:	8526                	mv	a0,s1
    80004110:	00002097          	auipc	ra,0x2
    80004114:	2cc080e7          	jalr	716(ra) # 800063dc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004118:	2184a703          	lw	a4,536(s1)
    8000411c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004120:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004124:	02f71963          	bne	a4,a5,80004156 <piperead+0x6a>
    80004128:	2244a783          	lw	a5,548(s1)
    8000412c:	cf95                	beqz	a5,80004168 <piperead+0x7c>
    if(killed(pr)){
    8000412e:	8552                	mv	a0,s4
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	776080e7          	jalr	1910(ra) # 800018a6 <killed>
    80004138:	e10d                	bnez	a0,8000415a <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000413a:	85a6                	mv	a1,s1
    8000413c:	854e                	mv	a0,s3
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	4c0080e7          	jalr	1216(ra) # 800015fe <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004146:	2184a703          	lw	a4,536(s1)
    8000414a:	21c4a783          	lw	a5,540(s1)
    8000414e:	fcf70de3          	beq	a4,a5,80004128 <piperead+0x3c>
    80004152:	e85a                	sd	s6,16(sp)
    80004154:	a819                	j	8000416a <piperead+0x7e>
    80004156:	e85a                	sd	s6,16(sp)
    80004158:	a809                	j	8000416a <piperead+0x7e>
      release(&pi->lock);
    8000415a:	8526                	mv	a0,s1
    8000415c:	00002097          	auipc	ra,0x2
    80004160:	334080e7          	jalr	820(ra) # 80006490 <release>
      return -1;
    80004164:	59fd                	li	s3,-1
    80004166:	a0a5                	j	800041ce <piperead+0xe2>
    80004168:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000416a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000416c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000416e:	05505463          	blez	s5,800041b6 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80004172:	2184a783          	lw	a5,536(s1)
    80004176:	21c4a703          	lw	a4,540(s1)
    8000417a:	02f70e63          	beq	a4,a5,800041b6 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000417e:	0017871b          	addw	a4,a5,1
    80004182:	20e4ac23          	sw	a4,536(s1)
    80004186:	1ff7f793          	and	a5,a5,511
    8000418a:	97a6                	add	a5,a5,s1
    8000418c:	0187c783          	lbu	a5,24(a5)
    80004190:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004194:	4685                	li	a3,1
    80004196:	fbf40613          	add	a2,s0,-65
    8000419a:	85ca                	mv	a1,s2
    8000419c:	050a3503          	ld	a0,80(s4)
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	9f6080e7          	jalr	-1546(ra) # 80000b96 <copyout>
    800041a8:	01650763          	beq	a0,s6,800041b6 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ac:	2985                	addw	s3,s3,1
    800041ae:	0905                	add	s2,s2,1
    800041b0:	fd3a91e3          	bne	s5,s3,80004172 <piperead+0x86>
    800041b4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041b6:	21c48513          	add	a0,s1,540
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	4a8080e7          	jalr	1192(ra) # 80001662 <wakeup>
  release(&pi->lock);
    800041c2:	8526                	mv	a0,s1
    800041c4:	00002097          	auipc	ra,0x2
    800041c8:	2cc080e7          	jalr	716(ra) # 80006490 <release>
    800041cc:	6b42                	ld	s6,16(sp)
  return i;
}
    800041ce:	854e                	mv	a0,s3
    800041d0:	60a6                	ld	ra,72(sp)
    800041d2:	6406                	ld	s0,64(sp)
    800041d4:	74e2                	ld	s1,56(sp)
    800041d6:	7942                	ld	s2,48(sp)
    800041d8:	79a2                	ld	s3,40(sp)
    800041da:	7a02                	ld	s4,32(sp)
    800041dc:	6ae2                	ld	s5,24(sp)
    800041de:	6161                	add	sp,sp,80
    800041e0:	8082                	ret

00000000800041e2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041e2:	1141                	add	sp,sp,-16
    800041e4:	e422                	sd	s0,8(sp)
    800041e6:	0800                	add	s0,sp,16
    800041e8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041ea:	8905                	and	a0,a0,1
    800041ec:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800041ee:	8b89                	and	a5,a5,2
    800041f0:	c399                	beqz	a5,800041f6 <flags2perm+0x14>
      perm |= PTE_W;
    800041f2:	00456513          	or	a0,a0,4
    return perm;
}
    800041f6:	6422                	ld	s0,8(sp)
    800041f8:	0141                	add	sp,sp,16
    800041fa:	8082                	ret

00000000800041fc <exec>:

int
exec(char *path, char **argv)
{
    800041fc:	df010113          	add	sp,sp,-528
    80004200:	20113423          	sd	ra,520(sp)
    80004204:	20813023          	sd	s0,512(sp)
    80004208:	ffa6                	sd	s1,504(sp)
    8000420a:	fbca                	sd	s2,496(sp)
    8000420c:	0c00                	add	s0,sp,528
    8000420e:	892a                	mv	s2,a0
    80004210:	dea43c23          	sd	a0,-520(s0)
    80004214:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	d38080e7          	jalr	-712(ra) # 80000f50 <myproc>
    80004220:	84aa                	mv	s1,a0

  begin_op();
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	43a080e7          	jalr	1082(ra) # 8000365c <begin_op>

  if((ip = namei(path)) == 0){
    8000422a:	854a                	mv	a0,s2
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	230080e7          	jalr	560(ra) # 8000345c <namei>
    80004234:	c135                	beqz	a0,80004298 <exec+0x9c>
    80004236:	f3d2                	sd	s4,480(sp)
    80004238:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	a54080e7          	jalr	-1452(ra) # 80002c8e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004242:	04000713          	li	a4,64
    80004246:	4681                	li	a3,0
    80004248:	e5040613          	add	a2,s0,-432
    8000424c:	4581                	li	a1,0
    8000424e:	8552                	mv	a0,s4
    80004250:	fffff097          	auipc	ra,0xfffff
    80004254:	cf6080e7          	jalr	-778(ra) # 80002f46 <readi>
    80004258:	04000793          	li	a5,64
    8000425c:	00f51a63          	bne	a0,a5,80004270 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004260:	e5042703          	lw	a4,-432(s0)
    80004264:	464c47b7          	lui	a5,0x464c4
    80004268:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000426c:	02f70c63          	beq	a4,a5,800042a4 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004270:	8552                	mv	a0,s4
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	c82080e7          	jalr	-894(ra) # 80002ef4 <iunlockput>
    end_op();
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	45c080e7          	jalr	1116(ra) # 800036d6 <end_op>
  }
  return -1;
    80004282:	557d                	li	a0,-1
    80004284:	7a1e                	ld	s4,480(sp)
}
    80004286:	20813083          	ld	ra,520(sp)
    8000428a:	20013403          	ld	s0,512(sp)
    8000428e:	74fe                	ld	s1,504(sp)
    80004290:	795e                	ld	s2,496(sp)
    80004292:	21010113          	add	sp,sp,528
    80004296:	8082                	ret
    end_op();
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	43e080e7          	jalr	1086(ra) # 800036d6 <end_op>
    return -1;
    800042a0:	557d                	li	a0,-1
    800042a2:	b7d5                	j	80004286 <exec+0x8a>
    800042a4:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800042a6:	8526                	mv	a0,s1
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	d70080e7          	jalr	-656(ra) # 80001018 <proc_pagetable>
    800042b0:	8b2a                	mv	s6,a0
    800042b2:	30050f63          	beqz	a0,800045d0 <exec+0x3d4>
    800042b6:	f7ce                	sd	s3,488(sp)
    800042b8:	efd6                	sd	s5,472(sp)
    800042ba:	e7de                	sd	s7,456(sp)
    800042bc:	e3e2                	sd	s8,448(sp)
    800042be:	ff66                	sd	s9,440(sp)
    800042c0:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042c2:	e7042d03          	lw	s10,-400(s0)
    800042c6:	e8845783          	lhu	a5,-376(s0)
    800042ca:	14078d63          	beqz	a5,80004424 <exec+0x228>
    800042ce:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042d0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d2:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800042d4:	6c85                	lui	s9,0x1
    800042d6:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042da:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800042de:	6a85                	lui	s5,0x1
    800042e0:	a0b5                	j	8000434c <exec+0x150>
      panic("loadseg: address should exist");
    800042e2:	00004517          	auipc	a0,0x4
    800042e6:	2b650513          	add	a0,a0,694 # 80008598 <etext+0x598>
    800042ea:	00002097          	auipc	ra,0x2
    800042ee:	b78080e7          	jalr	-1160(ra) # 80005e62 <panic>
    if(sz - i < PGSIZE)
    800042f2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042f4:	8726                	mv	a4,s1
    800042f6:	012c06bb          	addw	a3,s8,s2
    800042fa:	4581                	li	a1,0
    800042fc:	8552                	mv	a0,s4
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	c48080e7          	jalr	-952(ra) # 80002f46 <readi>
    80004306:	2501                	sext.w	a0,a0
    80004308:	28a49863          	bne	s1,a0,80004598 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    8000430c:	012a893b          	addw	s2,s5,s2
    80004310:	03397563          	bgeu	s2,s3,8000433a <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004314:	02091593          	sll	a1,s2,0x20
    80004318:	9181                	srl	a1,a1,0x20
    8000431a:	95de                	add	a1,a1,s7
    8000431c:	855a                	mv	a0,s6
    8000431e:	ffffc097          	auipc	ra,0xffffc
    80004322:	228080e7          	jalr	552(ra) # 80000546 <walkaddr>
    80004326:	862a                	mv	a2,a0
    if(pa == 0)
    80004328:	dd4d                	beqz	a0,800042e2 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000432a:	412984bb          	subw	s1,s3,s2
    8000432e:	0004879b          	sext.w	a5,s1
    80004332:	fcfcf0e3          	bgeu	s9,a5,800042f2 <exec+0xf6>
    80004336:	84d6                	mv	s1,s5
    80004338:	bf6d                	j	800042f2 <exec+0xf6>
    sz = sz1;
    8000433a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000433e:	2d85                	addw	s11,s11,1
    80004340:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004344:	e8845783          	lhu	a5,-376(s0)
    80004348:	08fdd663          	bge	s11,a5,800043d4 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000434c:	2d01                	sext.w	s10,s10
    8000434e:	03800713          	li	a4,56
    80004352:	86ea                	mv	a3,s10
    80004354:	e1840613          	add	a2,s0,-488
    80004358:	4581                	li	a1,0
    8000435a:	8552                	mv	a0,s4
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	bea080e7          	jalr	-1046(ra) # 80002f46 <readi>
    80004364:	03800793          	li	a5,56
    80004368:	20f51063          	bne	a0,a5,80004568 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    8000436c:	e1842783          	lw	a5,-488(s0)
    80004370:	4705                	li	a4,1
    80004372:	fce796e3          	bne	a5,a4,8000433e <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004376:	e4043483          	ld	s1,-448(s0)
    8000437a:	e3843783          	ld	a5,-456(s0)
    8000437e:	1ef4e963          	bltu	s1,a5,80004570 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004382:	e2843783          	ld	a5,-472(s0)
    80004386:	94be                	add	s1,s1,a5
    80004388:	1ef4e863          	bltu	s1,a5,80004578 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    8000438c:	df043703          	ld	a4,-528(s0)
    80004390:	8ff9                	and	a5,a5,a4
    80004392:	1e079763          	bnez	a5,80004580 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004396:	e1c42503          	lw	a0,-484(s0)
    8000439a:	00000097          	auipc	ra,0x0
    8000439e:	e48080e7          	jalr	-440(ra) # 800041e2 <flags2perm>
    800043a2:	86aa                	mv	a3,a0
    800043a4:	8626                	mv	a2,s1
    800043a6:	85ca                	mv	a1,s2
    800043a8:	855a                	mv	a0,s6
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	584080e7          	jalr	1412(ra) # 8000092e <uvmalloc>
    800043b2:	e0a43423          	sd	a0,-504(s0)
    800043b6:	1c050963          	beqz	a0,80004588 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043ba:	e2843b83          	ld	s7,-472(s0)
    800043be:	e2042c03          	lw	s8,-480(s0)
    800043c2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043c6:	00098463          	beqz	s3,800043ce <exec+0x1d2>
    800043ca:	4901                	li	s2,0
    800043cc:	b7a1                	j	80004314 <exec+0x118>
    sz = sz1;
    800043ce:	e0843903          	ld	s2,-504(s0)
    800043d2:	b7b5                	j	8000433e <exec+0x142>
    800043d4:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800043d6:	8552                	mv	a0,s4
    800043d8:	fffff097          	auipc	ra,0xfffff
    800043dc:	b1c080e7          	jalr	-1252(ra) # 80002ef4 <iunlockput>
  end_op();
    800043e0:	fffff097          	auipc	ra,0xfffff
    800043e4:	2f6080e7          	jalr	758(ra) # 800036d6 <end_op>
  p = myproc();
    800043e8:	ffffd097          	auipc	ra,0xffffd
    800043ec:	b68080e7          	jalr	-1176(ra) # 80000f50 <myproc>
    800043f0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043f2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800043f6:	6985                	lui	s3,0x1
    800043f8:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800043fa:	99ca                	add	s3,s3,s2
    800043fc:	77fd                	lui	a5,0xfffff
    800043fe:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004402:	4691                	li	a3,4
    80004404:	6609                	lui	a2,0x2
    80004406:	964e                	add	a2,a2,s3
    80004408:	85ce                	mv	a1,s3
    8000440a:	855a                	mv	a0,s6
    8000440c:	ffffc097          	auipc	ra,0xffffc
    80004410:	522080e7          	jalr	1314(ra) # 8000092e <uvmalloc>
    80004414:	892a                	mv	s2,a0
    80004416:	e0a43423          	sd	a0,-504(s0)
    8000441a:	e519                	bnez	a0,80004428 <exec+0x22c>
  if(pagetable)
    8000441c:	e1343423          	sd	s3,-504(s0)
    80004420:	4a01                	li	s4,0
    80004422:	aaa5                	j	8000459a <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004424:	4901                	li	s2,0
    80004426:	bf45                	j	800043d6 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004428:	75f9                	lui	a1,0xffffe
    8000442a:	95aa                	add	a1,a1,a0
    8000442c:	855a                	mv	a0,s6
    8000442e:	ffffc097          	auipc	ra,0xffffc
    80004432:	736080e7          	jalr	1846(ra) # 80000b64 <uvmclear>
  stackbase = sp - PGSIZE;
    80004436:	7bfd                	lui	s7,0xfffff
    80004438:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000443a:	e0043783          	ld	a5,-512(s0)
    8000443e:	6388                	ld	a0,0(a5)
    80004440:	c52d                	beqz	a0,800044aa <exec+0x2ae>
    80004442:	e9040993          	add	s3,s0,-368
    80004446:	f9040c13          	add	s8,s0,-112
    8000444a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000444c:	ffffc097          	auipc	ra,0xffffc
    80004450:	eec080e7          	jalr	-276(ra) # 80000338 <strlen>
    80004454:	0015079b          	addw	a5,a0,1
    80004458:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000445c:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004460:	13796863          	bltu	s2,s7,80004590 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004464:	e0043d03          	ld	s10,-512(s0)
    80004468:	000d3a03          	ld	s4,0(s10)
    8000446c:	8552                	mv	a0,s4
    8000446e:	ffffc097          	auipc	ra,0xffffc
    80004472:	eca080e7          	jalr	-310(ra) # 80000338 <strlen>
    80004476:	0015069b          	addw	a3,a0,1
    8000447a:	8652                	mv	a2,s4
    8000447c:	85ca                	mv	a1,s2
    8000447e:	855a                	mv	a0,s6
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	716080e7          	jalr	1814(ra) # 80000b96 <copyout>
    80004488:	10054663          	bltz	a0,80004594 <exec+0x398>
    ustack[argc] = sp;
    8000448c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004490:	0485                	add	s1,s1,1
    80004492:	008d0793          	add	a5,s10,8
    80004496:	e0f43023          	sd	a5,-512(s0)
    8000449a:	008d3503          	ld	a0,8(s10)
    8000449e:	c909                	beqz	a0,800044b0 <exec+0x2b4>
    if(argc >= MAXARG)
    800044a0:	09a1                	add	s3,s3,8
    800044a2:	fb8995e3          	bne	s3,s8,8000444c <exec+0x250>
  ip = 0;
    800044a6:	4a01                	li	s4,0
    800044a8:	a8cd                	j	8000459a <exec+0x39e>
  sp = sz;
    800044aa:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800044ae:	4481                	li	s1,0
  ustack[argc] = 0;
    800044b0:	00349793          	sll	a5,s1,0x3
    800044b4:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd210>
    800044b8:	97a2                	add	a5,a5,s0
    800044ba:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800044be:	00148693          	add	a3,s1,1
    800044c2:	068e                	sll	a3,a3,0x3
    800044c4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044c8:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800044cc:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800044d0:	f57966e3          	bltu	s2,s7,8000441c <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044d4:	e9040613          	add	a2,s0,-368
    800044d8:	85ca                	mv	a1,s2
    800044da:	855a                	mv	a0,s6
    800044dc:	ffffc097          	auipc	ra,0xffffc
    800044e0:	6ba080e7          	jalr	1722(ra) # 80000b96 <copyout>
    800044e4:	0e054863          	bltz	a0,800045d4 <exec+0x3d8>
  p->trapframe->a1 = sp;
    800044e8:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800044ec:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044f0:	df843783          	ld	a5,-520(s0)
    800044f4:	0007c703          	lbu	a4,0(a5)
    800044f8:	cf11                	beqz	a4,80004514 <exec+0x318>
    800044fa:	0785                	add	a5,a5,1
    if(*s == '/')
    800044fc:	02f00693          	li	a3,47
    80004500:	a039                	j	8000450e <exec+0x312>
      last = s+1;
    80004502:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004506:	0785                	add	a5,a5,1
    80004508:	fff7c703          	lbu	a4,-1(a5)
    8000450c:	c701                	beqz	a4,80004514 <exec+0x318>
    if(*s == '/')
    8000450e:	fed71ce3          	bne	a4,a3,80004506 <exec+0x30a>
    80004512:	bfc5                	j	80004502 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80004514:	4641                	li	a2,16
    80004516:	df843583          	ld	a1,-520(s0)
    8000451a:	158a8513          	add	a0,s5,344
    8000451e:	ffffc097          	auipc	ra,0xffffc
    80004522:	de8080e7          	jalr	-536(ra) # 80000306 <safestrcpy>
  oldpagetable = p->pagetable;
    80004526:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000452a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000452e:	e0843783          	ld	a5,-504(s0)
    80004532:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004536:	058ab783          	ld	a5,88(s5)
    8000453a:	e6843703          	ld	a4,-408(s0)
    8000453e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004540:	058ab783          	ld	a5,88(s5)
    80004544:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004548:	85e6                	mv	a1,s9
    8000454a:	ffffd097          	auipc	ra,0xffffd
    8000454e:	b6a080e7          	jalr	-1174(ra) # 800010b4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004552:	0004851b          	sext.w	a0,s1
    80004556:	79be                	ld	s3,488(sp)
    80004558:	7a1e                	ld	s4,480(sp)
    8000455a:	6afe                	ld	s5,472(sp)
    8000455c:	6b5e                	ld	s6,464(sp)
    8000455e:	6bbe                	ld	s7,456(sp)
    80004560:	6c1e                	ld	s8,448(sp)
    80004562:	7cfa                	ld	s9,440(sp)
    80004564:	7d5a                	ld	s10,432(sp)
    80004566:	b305                	j	80004286 <exec+0x8a>
    80004568:	e1243423          	sd	s2,-504(s0)
    8000456c:	7dba                	ld	s11,424(sp)
    8000456e:	a035                	j	8000459a <exec+0x39e>
    80004570:	e1243423          	sd	s2,-504(s0)
    80004574:	7dba                	ld	s11,424(sp)
    80004576:	a015                	j	8000459a <exec+0x39e>
    80004578:	e1243423          	sd	s2,-504(s0)
    8000457c:	7dba                	ld	s11,424(sp)
    8000457e:	a831                	j	8000459a <exec+0x39e>
    80004580:	e1243423          	sd	s2,-504(s0)
    80004584:	7dba                	ld	s11,424(sp)
    80004586:	a811                	j	8000459a <exec+0x39e>
    80004588:	e1243423          	sd	s2,-504(s0)
    8000458c:	7dba                	ld	s11,424(sp)
    8000458e:	a031                	j	8000459a <exec+0x39e>
  ip = 0;
    80004590:	4a01                	li	s4,0
    80004592:	a021                	j	8000459a <exec+0x39e>
    80004594:	4a01                	li	s4,0
  if(pagetable)
    80004596:	a011                	j	8000459a <exec+0x39e>
    80004598:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000459a:	e0843583          	ld	a1,-504(s0)
    8000459e:	855a                	mv	a0,s6
    800045a0:	ffffd097          	auipc	ra,0xffffd
    800045a4:	b14080e7          	jalr	-1260(ra) # 800010b4 <proc_freepagetable>
  return -1;
    800045a8:	557d                	li	a0,-1
  if(ip){
    800045aa:	000a1b63          	bnez	s4,800045c0 <exec+0x3c4>
    800045ae:	79be                	ld	s3,488(sp)
    800045b0:	7a1e                	ld	s4,480(sp)
    800045b2:	6afe                	ld	s5,472(sp)
    800045b4:	6b5e                	ld	s6,464(sp)
    800045b6:	6bbe                	ld	s7,456(sp)
    800045b8:	6c1e                	ld	s8,448(sp)
    800045ba:	7cfa                	ld	s9,440(sp)
    800045bc:	7d5a                	ld	s10,432(sp)
    800045be:	b1e1                	j	80004286 <exec+0x8a>
    800045c0:	79be                	ld	s3,488(sp)
    800045c2:	6afe                	ld	s5,472(sp)
    800045c4:	6b5e                	ld	s6,464(sp)
    800045c6:	6bbe                	ld	s7,456(sp)
    800045c8:	6c1e                	ld	s8,448(sp)
    800045ca:	7cfa                	ld	s9,440(sp)
    800045cc:	7d5a                	ld	s10,432(sp)
    800045ce:	b14d                	j	80004270 <exec+0x74>
    800045d0:	6b5e                	ld	s6,464(sp)
    800045d2:	b979                	j	80004270 <exec+0x74>
  sz = sz1;
    800045d4:	e0843983          	ld	s3,-504(s0)
    800045d8:	b591                	j	8000441c <exec+0x220>

00000000800045da <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045da:	7179                	add	sp,sp,-48
    800045dc:	f406                	sd	ra,40(sp)
    800045de:	f022                	sd	s0,32(sp)
    800045e0:	ec26                	sd	s1,24(sp)
    800045e2:	e84a                	sd	s2,16(sp)
    800045e4:	1800                	add	s0,sp,48
    800045e6:	892e                	mv	s2,a1
    800045e8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800045ea:	fdc40593          	add	a1,s0,-36
    800045ee:	ffffe097          	auipc	ra,0xffffe
    800045f2:	b08080e7          	jalr	-1272(ra) # 800020f6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045f6:	fdc42703          	lw	a4,-36(s0)
    800045fa:	47bd                	li	a5,15
    800045fc:	02e7eb63          	bltu	a5,a4,80004632 <argfd+0x58>
    80004600:	ffffd097          	auipc	ra,0xffffd
    80004604:	950080e7          	jalr	-1712(ra) # 80000f50 <myproc>
    80004608:	fdc42703          	lw	a4,-36(s0)
    8000460c:	01a70793          	add	a5,a4,26
    80004610:	078e                	sll	a5,a5,0x3
    80004612:	953e                	add	a0,a0,a5
    80004614:	611c                	ld	a5,0(a0)
    80004616:	c385                	beqz	a5,80004636 <argfd+0x5c>
    return -1;
  if(pfd)
    80004618:	00090463          	beqz	s2,80004620 <argfd+0x46>
    *pfd = fd;
    8000461c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004620:	4501                	li	a0,0
  if(pf)
    80004622:	c091                	beqz	s1,80004626 <argfd+0x4c>
    *pf = f;
    80004624:	e09c                	sd	a5,0(s1)
}
    80004626:	70a2                	ld	ra,40(sp)
    80004628:	7402                	ld	s0,32(sp)
    8000462a:	64e2                	ld	s1,24(sp)
    8000462c:	6942                	ld	s2,16(sp)
    8000462e:	6145                	add	sp,sp,48
    80004630:	8082                	ret
    return -1;
    80004632:	557d                	li	a0,-1
    80004634:	bfcd                	j	80004626 <argfd+0x4c>
    80004636:	557d                	li	a0,-1
    80004638:	b7fd                	j	80004626 <argfd+0x4c>

000000008000463a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000463a:	1101                	add	sp,sp,-32
    8000463c:	ec06                	sd	ra,24(sp)
    8000463e:	e822                	sd	s0,16(sp)
    80004640:	e426                	sd	s1,8(sp)
    80004642:	1000                	add	s0,sp,32
    80004644:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004646:	ffffd097          	auipc	ra,0xffffd
    8000464a:	90a080e7          	jalr	-1782(ra) # 80000f50 <myproc>
    8000464e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004650:	0d050793          	add	a5,a0,208
    80004654:	4501                	li	a0,0
    80004656:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004658:	6398                	ld	a4,0(a5)
    8000465a:	cb19                	beqz	a4,80004670 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000465c:	2505                	addw	a0,a0,1
    8000465e:	07a1                	add	a5,a5,8
    80004660:	fed51ce3          	bne	a0,a3,80004658 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004664:	557d                	li	a0,-1
}
    80004666:	60e2                	ld	ra,24(sp)
    80004668:	6442                	ld	s0,16(sp)
    8000466a:	64a2                	ld	s1,8(sp)
    8000466c:	6105                	add	sp,sp,32
    8000466e:	8082                	ret
      p->ofile[fd] = f;
    80004670:	01a50793          	add	a5,a0,26
    80004674:	078e                	sll	a5,a5,0x3
    80004676:	963e                	add	a2,a2,a5
    80004678:	e204                	sd	s1,0(a2)
      return fd;
    8000467a:	b7f5                	j	80004666 <fdalloc+0x2c>

000000008000467c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000467c:	715d                	add	sp,sp,-80
    8000467e:	e486                	sd	ra,72(sp)
    80004680:	e0a2                	sd	s0,64(sp)
    80004682:	fc26                	sd	s1,56(sp)
    80004684:	f84a                	sd	s2,48(sp)
    80004686:	f44e                	sd	s3,40(sp)
    80004688:	ec56                	sd	s5,24(sp)
    8000468a:	e85a                	sd	s6,16(sp)
    8000468c:	0880                	add	s0,sp,80
    8000468e:	8b2e                	mv	s6,a1
    80004690:	89b2                	mv	s3,a2
    80004692:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004694:	fb040593          	add	a1,s0,-80
    80004698:	fffff097          	auipc	ra,0xfffff
    8000469c:	de2080e7          	jalr	-542(ra) # 8000347a <nameiparent>
    800046a0:	84aa                	mv	s1,a0
    800046a2:	14050e63          	beqz	a0,800047fe <create+0x182>
    return 0;

  ilock(dp);
    800046a6:	ffffe097          	auipc	ra,0xffffe
    800046aa:	5e8080e7          	jalr	1512(ra) # 80002c8e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046ae:	4601                	li	a2,0
    800046b0:	fb040593          	add	a1,s0,-80
    800046b4:	8526                	mv	a0,s1
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	ae4080e7          	jalr	-1308(ra) # 8000319a <dirlookup>
    800046be:	8aaa                	mv	s5,a0
    800046c0:	c539                	beqz	a0,8000470e <create+0x92>
    iunlockput(dp);
    800046c2:	8526                	mv	a0,s1
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	830080e7          	jalr	-2000(ra) # 80002ef4 <iunlockput>
    ilock(ip);
    800046cc:	8556                	mv	a0,s5
    800046ce:	ffffe097          	auipc	ra,0xffffe
    800046d2:	5c0080e7          	jalr	1472(ra) # 80002c8e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046d6:	4789                	li	a5,2
    800046d8:	02fb1463          	bne	s6,a5,80004700 <create+0x84>
    800046dc:	044ad783          	lhu	a5,68(s5)
    800046e0:	37f9                	addw	a5,a5,-2
    800046e2:	17c2                	sll	a5,a5,0x30
    800046e4:	93c1                	srl	a5,a5,0x30
    800046e6:	4705                	li	a4,1
    800046e8:	00f76c63          	bltu	a4,a5,80004700 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800046ec:	8556                	mv	a0,s5
    800046ee:	60a6                	ld	ra,72(sp)
    800046f0:	6406                	ld	s0,64(sp)
    800046f2:	74e2                	ld	s1,56(sp)
    800046f4:	7942                	ld	s2,48(sp)
    800046f6:	79a2                	ld	s3,40(sp)
    800046f8:	6ae2                	ld	s5,24(sp)
    800046fa:	6b42                	ld	s6,16(sp)
    800046fc:	6161                	add	sp,sp,80
    800046fe:	8082                	ret
    iunlockput(ip);
    80004700:	8556                	mv	a0,s5
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	7f2080e7          	jalr	2034(ra) # 80002ef4 <iunlockput>
    return 0;
    8000470a:	4a81                	li	s5,0
    8000470c:	b7c5                	j	800046ec <create+0x70>
    8000470e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004710:	85da                	mv	a1,s6
    80004712:	4088                	lw	a0,0(s1)
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	3d6080e7          	jalr	982(ra) # 80002aea <ialloc>
    8000471c:	8a2a                	mv	s4,a0
    8000471e:	c531                	beqz	a0,8000476a <create+0xee>
  ilock(ip);
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	56e080e7          	jalr	1390(ra) # 80002c8e <ilock>
  ip->major = major;
    80004728:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000472c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004730:	4905                	li	s2,1
    80004732:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004736:	8552                	mv	a0,s4
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	48a080e7          	jalr	1162(ra) # 80002bc2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004740:	032b0d63          	beq	s6,s2,8000477a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004744:	004a2603          	lw	a2,4(s4)
    80004748:	fb040593          	add	a1,s0,-80
    8000474c:	8526                	mv	a0,s1
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	c5c080e7          	jalr	-932(ra) # 800033aa <dirlink>
    80004756:	08054163          	bltz	a0,800047d8 <create+0x15c>
  iunlockput(dp);
    8000475a:	8526                	mv	a0,s1
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	798080e7          	jalr	1944(ra) # 80002ef4 <iunlockput>
  return ip;
    80004764:	8ad2                	mv	s5,s4
    80004766:	7a02                	ld	s4,32(sp)
    80004768:	b751                	j	800046ec <create+0x70>
    iunlockput(dp);
    8000476a:	8526                	mv	a0,s1
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	788080e7          	jalr	1928(ra) # 80002ef4 <iunlockput>
    return 0;
    80004774:	8ad2                	mv	s5,s4
    80004776:	7a02                	ld	s4,32(sp)
    80004778:	bf95                	j	800046ec <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000477a:	004a2603          	lw	a2,4(s4)
    8000477e:	00004597          	auipc	a1,0x4
    80004782:	e3a58593          	add	a1,a1,-454 # 800085b8 <etext+0x5b8>
    80004786:	8552                	mv	a0,s4
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	c22080e7          	jalr	-990(ra) # 800033aa <dirlink>
    80004790:	04054463          	bltz	a0,800047d8 <create+0x15c>
    80004794:	40d0                	lw	a2,4(s1)
    80004796:	00004597          	auipc	a1,0x4
    8000479a:	e2a58593          	add	a1,a1,-470 # 800085c0 <etext+0x5c0>
    8000479e:	8552                	mv	a0,s4
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	c0a080e7          	jalr	-1014(ra) # 800033aa <dirlink>
    800047a8:	02054863          	bltz	a0,800047d8 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ac:	004a2603          	lw	a2,4(s4)
    800047b0:	fb040593          	add	a1,s0,-80
    800047b4:	8526                	mv	a0,s1
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	bf4080e7          	jalr	-1036(ra) # 800033aa <dirlink>
    800047be:	00054d63          	bltz	a0,800047d8 <create+0x15c>
    dp->nlink++;  // for ".."
    800047c2:	04a4d783          	lhu	a5,74(s1)
    800047c6:	2785                	addw	a5,a5,1
    800047c8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047cc:	8526                	mv	a0,s1
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	3f4080e7          	jalr	1012(ra) # 80002bc2 <iupdate>
    800047d6:	b751                	j	8000475a <create+0xde>
  ip->nlink = 0;
    800047d8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047dc:	8552                	mv	a0,s4
    800047de:	ffffe097          	auipc	ra,0xffffe
    800047e2:	3e4080e7          	jalr	996(ra) # 80002bc2 <iupdate>
  iunlockput(ip);
    800047e6:	8552                	mv	a0,s4
    800047e8:	ffffe097          	auipc	ra,0xffffe
    800047ec:	70c080e7          	jalr	1804(ra) # 80002ef4 <iunlockput>
  iunlockput(dp);
    800047f0:	8526                	mv	a0,s1
    800047f2:	ffffe097          	auipc	ra,0xffffe
    800047f6:	702080e7          	jalr	1794(ra) # 80002ef4 <iunlockput>
  return 0;
    800047fa:	7a02                	ld	s4,32(sp)
    800047fc:	bdc5                	j	800046ec <create+0x70>
    return 0;
    800047fe:	8aaa                	mv	s5,a0
    80004800:	b5f5                	j	800046ec <create+0x70>

0000000080004802 <sys_dup>:
{
    80004802:	7179                	add	sp,sp,-48
    80004804:	f406                	sd	ra,40(sp)
    80004806:	f022                	sd	s0,32(sp)
    80004808:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000480a:	fd840613          	add	a2,s0,-40
    8000480e:	4581                	li	a1,0
    80004810:	4501                	li	a0,0
    80004812:	00000097          	auipc	ra,0x0
    80004816:	dc8080e7          	jalr	-568(ra) # 800045da <argfd>
    return -1;
    8000481a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000481c:	02054763          	bltz	a0,8000484a <sys_dup+0x48>
    80004820:	ec26                	sd	s1,24(sp)
    80004822:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004824:	fd843903          	ld	s2,-40(s0)
    80004828:	854a                	mv	a0,s2
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	e10080e7          	jalr	-496(ra) # 8000463a <fdalloc>
    80004832:	84aa                	mv	s1,a0
    return -1;
    80004834:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004836:	00054f63          	bltz	a0,80004854 <sys_dup+0x52>
  filedup(f);
    8000483a:	854a                	mv	a0,s2
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	298080e7          	jalr	664(ra) # 80003ad4 <filedup>
  return fd;
    80004844:	87a6                	mv	a5,s1
    80004846:	64e2                	ld	s1,24(sp)
    80004848:	6942                	ld	s2,16(sp)
}
    8000484a:	853e                	mv	a0,a5
    8000484c:	70a2                	ld	ra,40(sp)
    8000484e:	7402                	ld	s0,32(sp)
    80004850:	6145                	add	sp,sp,48
    80004852:	8082                	ret
    80004854:	64e2                	ld	s1,24(sp)
    80004856:	6942                	ld	s2,16(sp)
    80004858:	bfcd                	j	8000484a <sys_dup+0x48>

000000008000485a <sys_read>:
{
    8000485a:	7179                	add	sp,sp,-48
    8000485c:	f406                	sd	ra,40(sp)
    8000485e:	f022                	sd	s0,32(sp)
    80004860:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004862:	fd840593          	add	a1,s0,-40
    80004866:	4505                	li	a0,1
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	8ae080e7          	jalr	-1874(ra) # 80002116 <argaddr>
  argint(2, &n);
    80004870:	fe440593          	add	a1,s0,-28
    80004874:	4509                	li	a0,2
    80004876:	ffffe097          	auipc	ra,0xffffe
    8000487a:	880080e7          	jalr	-1920(ra) # 800020f6 <argint>
  if(argfd(0, 0, &f) < 0)
    8000487e:	fe840613          	add	a2,s0,-24
    80004882:	4581                	li	a1,0
    80004884:	4501                	li	a0,0
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	d54080e7          	jalr	-684(ra) # 800045da <argfd>
    8000488e:	87aa                	mv	a5,a0
    return -1;
    80004890:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004892:	0007cc63          	bltz	a5,800048aa <sys_read+0x50>
  return fileread(f, p, n);
    80004896:	fe442603          	lw	a2,-28(s0)
    8000489a:	fd843583          	ld	a1,-40(s0)
    8000489e:	fe843503          	ld	a0,-24(s0)
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	3d8080e7          	jalr	984(ra) # 80003c7a <fileread>
}
    800048aa:	70a2                	ld	ra,40(sp)
    800048ac:	7402                	ld	s0,32(sp)
    800048ae:	6145                	add	sp,sp,48
    800048b0:	8082                	ret

00000000800048b2 <sys_write>:
{
    800048b2:	7179                	add	sp,sp,-48
    800048b4:	f406                	sd	ra,40(sp)
    800048b6:	f022                	sd	s0,32(sp)
    800048b8:	1800                	add	s0,sp,48
  argaddr(1, &p);
    800048ba:	fd840593          	add	a1,s0,-40
    800048be:	4505                	li	a0,1
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	856080e7          	jalr	-1962(ra) # 80002116 <argaddr>
  argint(2, &n);
    800048c8:	fe440593          	add	a1,s0,-28
    800048cc:	4509                	li	a0,2
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	828080e7          	jalr	-2008(ra) # 800020f6 <argint>
  if(argfd(0, 0, &f) < 0)
    800048d6:	fe840613          	add	a2,s0,-24
    800048da:	4581                	li	a1,0
    800048dc:	4501                	li	a0,0
    800048de:	00000097          	auipc	ra,0x0
    800048e2:	cfc080e7          	jalr	-772(ra) # 800045da <argfd>
    800048e6:	87aa                	mv	a5,a0
    return -1;
    800048e8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048ea:	0007cc63          	bltz	a5,80004902 <sys_write+0x50>
  return filewrite(f, p, n);
    800048ee:	fe442603          	lw	a2,-28(s0)
    800048f2:	fd843583          	ld	a1,-40(s0)
    800048f6:	fe843503          	ld	a0,-24(s0)
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	452080e7          	jalr	1106(ra) # 80003d4c <filewrite>
}
    80004902:	70a2                	ld	ra,40(sp)
    80004904:	7402                	ld	s0,32(sp)
    80004906:	6145                	add	sp,sp,48
    80004908:	8082                	ret

000000008000490a <sys_close>:
{
    8000490a:	1101                	add	sp,sp,-32
    8000490c:	ec06                	sd	ra,24(sp)
    8000490e:	e822                	sd	s0,16(sp)
    80004910:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004912:	fe040613          	add	a2,s0,-32
    80004916:	fec40593          	add	a1,s0,-20
    8000491a:	4501                	li	a0,0
    8000491c:	00000097          	auipc	ra,0x0
    80004920:	cbe080e7          	jalr	-834(ra) # 800045da <argfd>
    return -1;
    80004924:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004926:	02054463          	bltz	a0,8000494e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000492a:	ffffc097          	auipc	ra,0xffffc
    8000492e:	626080e7          	jalr	1574(ra) # 80000f50 <myproc>
    80004932:	fec42783          	lw	a5,-20(s0)
    80004936:	07e9                	add	a5,a5,26
    80004938:	078e                	sll	a5,a5,0x3
    8000493a:	953e                	add	a0,a0,a5
    8000493c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004940:	fe043503          	ld	a0,-32(s0)
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	1e2080e7          	jalr	482(ra) # 80003b26 <fileclose>
  return 0;
    8000494c:	4781                	li	a5,0
}
    8000494e:	853e                	mv	a0,a5
    80004950:	60e2                	ld	ra,24(sp)
    80004952:	6442                	ld	s0,16(sp)
    80004954:	6105                	add	sp,sp,32
    80004956:	8082                	ret

0000000080004958 <sys_fstat>:
{
    80004958:	1101                	add	sp,sp,-32
    8000495a:	ec06                	sd	ra,24(sp)
    8000495c:	e822                	sd	s0,16(sp)
    8000495e:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004960:	fe040593          	add	a1,s0,-32
    80004964:	4505                	li	a0,1
    80004966:	ffffd097          	auipc	ra,0xffffd
    8000496a:	7b0080e7          	jalr	1968(ra) # 80002116 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000496e:	fe840613          	add	a2,s0,-24
    80004972:	4581                	li	a1,0
    80004974:	4501                	li	a0,0
    80004976:	00000097          	auipc	ra,0x0
    8000497a:	c64080e7          	jalr	-924(ra) # 800045da <argfd>
    8000497e:	87aa                	mv	a5,a0
    return -1;
    80004980:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004982:	0007ca63          	bltz	a5,80004996 <sys_fstat+0x3e>
  return filestat(f, st);
    80004986:	fe043583          	ld	a1,-32(s0)
    8000498a:	fe843503          	ld	a0,-24(s0)
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	27a080e7          	jalr	634(ra) # 80003c08 <filestat>
}
    80004996:	60e2                	ld	ra,24(sp)
    80004998:	6442                	ld	s0,16(sp)
    8000499a:	6105                	add	sp,sp,32
    8000499c:	8082                	ret

000000008000499e <sys_link>:
{
    8000499e:	7169                	add	sp,sp,-304
    800049a0:	f606                	sd	ra,296(sp)
    800049a2:	f222                	sd	s0,288(sp)
    800049a4:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049a6:	08000613          	li	a2,128
    800049aa:	ed040593          	add	a1,s0,-304
    800049ae:	4501                	li	a0,0
    800049b0:	ffffd097          	auipc	ra,0xffffd
    800049b4:	786080e7          	jalr	1926(ra) # 80002136 <argstr>
    return -1;
    800049b8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ba:	12054663          	bltz	a0,80004ae6 <sys_link+0x148>
    800049be:	08000613          	li	a2,128
    800049c2:	f5040593          	add	a1,s0,-176
    800049c6:	4505                	li	a0,1
    800049c8:	ffffd097          	auipc	ra,0xffffd
    800049cc:	76e080e7          	jalr	1902(ra) # 80002136 <argstr>
    return -1;
    800049d0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d2:	10054a63          	bltz	a0,80004ae6 <sys_link+0x148>
    800049d6:	ee26                	sd	s1,280(sp)
  begin_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	c84080e7          	jalr	-892(ra) # 8000365c <begin_op>
  if((ip = namei(old)) == 0){
    800049e0:	ed040513          	add	a0,s0,-304
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	a78080e7          	jalr	-1416(ra) # 8000345c <namei>
    800049ec:	84aa                	mv	s1,a0
    800049ee:	c949                	beqz	a0,80004a80 <sys_link+0xe2>
  ilock(ip);
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	29e080e7          	jalr	670(ra) # 80002c8e <ilock>
  if(ip->type == T_DIR){
    800049f8:	04449703          	lh	a4,68(s1)
    800049fc:	4785                	li	a5,1
    800049fe:	08f70863          	beq	a4,a5,80004a8e <sys_link+0xf0>
    80004a02:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a04:	04a4d783          	lhu	a5,74(s1)
    80004a08:	2785                	addw	a5,a5,1
    80004a0a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	1b2080e7          	jalr	434(ra) # 80002bc2 <iupdate>
  iunlock(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	33a080e7          	jalr	826(ra) # 80002d54 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a22:	fd040593          	add	a1,s0,-48
    80004a26:	f5040513          	add	a0,s0,-176
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	a50080e7          	jalr	-1456(ra) # 8000347a <nameiparent>
    80004a32:	892a                	mv	s2,a0
    80004a34:	cd35                	beqz	a0,80004ab0 <sys_link+0x112>
  ilock(dp);
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	258080e7          	jalr	600(ra) # 80002c8e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a3e:	00092703          	lw	a4,0(s2)
    80004a42:	409c                	lw	a5,0(s1)
    80004a44:	06f71163          	bne	a4,a5,80004aa6 <sys_link+0x108>
    80004a48:	40d0                	lw	a2,4(s1)
    80004a4a:	fd040593          	add	a1,s0,-48
    80004a4e:	854a                	mv	a0,s2
    80004a50:	fffff097          	auipc	ra,0xfffff
    80004a54:	95a080e7          	jalr	-1702(ra) # 800033aa <dirlink>
    80004a58:	04054763          	bltz	a0,80004aa6 <sys_link+0x108>
  iunlockput(dp);
    80004a5c:	854a                	mv	a0,s2
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	496080e7          	jalr	1174(ra) # 80002ef4 <iunlockput>
  iput(ip);
    80004a66:	8526                	mv	a0,s1
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	3e4080e7          	jalr	996(ra) # 80002e4c <iput>
  end_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	c66080e7          	jalr	-922(ra) # 800036d6 <end_op>
  return 0;
    80004a78:	4781                	li	a5,0
    80004a7a:	64f2                	ld	s1,280(sp)
    80004a7c:	6952                	ld	s2,272(sp)
    80004a7e:	a0a5                	j	80004ae6 <sys_link+0x148>
    end_op();
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	c56080e7          	jalr	-938(ra) # 800036d6 <end_op>
    return -1;
    80004a88:	57fd                	li	a5,-1
    80004a8a:	64f2                	ld	s1,280(sp)
    80004a8c:	a8a9                	j	80004ae6 <sys_link+0x148>
    iunlockput(ip);
    80004a8e:	8526                	mv	a0,s1
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	464080e7          	jalr	1124(ra) # 80002ef4 <iunlockput>
    end_op();
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	c3e080e7          	jalr	-962(ra) # 800036d6 <end_op>
    return -1;
    80004aa0:	57fd                	li	a5,-1
    80004aa2:	64f2                	ld	s1,280(sp)
    80004aa4:	a089                	j	80004ae6 <sys_link+0x148>
    iunlockput(dp);
    80004aa6:	854a                	mv	a0,s2
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	44c080e7          	jalr	1100(ra) # 80002ef4 <iunlockput>
  ilock(ip);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	1dc080e7          	jalr	476(ra) # 80002c8e <ilock>
  ip->nlink--;
    80004aba:	04a4d783          	lhu	a5,74(s1)
    80004abe:	37fd                	addw	a5,a5,-1
    80004ac0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	0fc080e7          	jalr	252(ra) # 80002bc2 <iupdate>
  iunlockput(ip);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	424080e7          	jalr	1060(ra) # 80002ef4 <iunlockput>
  end_op();
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	bfe080e7          	jalr	-1026(ra) # 800036d6 <end_op>
  return -1;
    80004ae0:	57fd                	li	a5,-1
    80004ae2:	64f2                	ld	s1,280(sp)
    80004ae4:	6952                	ld	s2,272(sp)
}
    80004ae6:	853e                	mv	a0,a5
    80004ae8:	70b2                	ld	ra,296(sp)
    80004aea:	7412                	ld	s0,288(sp)
    80004aec:	6155                	add	sp,sp,304
    80004aee:	8082                	ret

0000000080004af0 <sys_unlink>:
{
    80004af0:	7151                	add	sp,sp,-240
    80004af2:	f586                	sd	ra,232(sp)
    80004af4:	f1a2                	sd	s0,224(sp)
    80004af6:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004af8:	08000613          	li	a2,128
    80004afc:	f3040593          	add	a1,s0,-208
    80004b00:	4501                	li	a0,0
    80004b02:	ffffd097          	auipc	ra,0xffffd
    80004b06:	634080e7          	jalr	1588(ra) # 80002136 <argstr>
    80004b0a:	1a054a63          	bltz	a0,80004cbe <sys_unlink+0x1ce>
    80004b0e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004b10:	fffff097          	auipc	ra,0xfffff
    80004b14:	b4c080e7          	jalr	-1204(ra) # 8000365c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b18:	fb040593          	add	a1,s0,-80
    80004b1c:	f3040513          	add	a0,s0,-208
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	95a080e7          	jalr	-1702(ra) # 8000347a <nameiparent>
    80004b28:	84aa                	mv	s1,a0
    80004b2a:	cd71                	beqz	a0,80004c06 <sys_unlink+0x116>
  ilock(dp);
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	162080e7          	jalr	354(ra) # 80002c8e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b34:	00004597          	auipc	a1,0x4
    80004b38:	a8458593          	add	a1,a1,-1404 # 800085b8 <etext+0x5b8>
    80004b3c:	fb040513          	add	a0,s0,-80
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	640080e7          	jalr	1600(ra) # 80003180 <namecmp>
    80004b48:	14050c63          	beqz	a0,80004ca0 <sys_unlink+0x1b0>
    80004b4c:	00004597          	auipc	a1,0x4
    80004b50:	a7458593          	add	a1,a1,-1420 # 800085c0 <etext+0x5c0>
    80004b54:	fb040513          	add	a0,s0,-80
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	628080e7          	jalr	1576(ra) # 80003180 <namecmp>
    80004b60:	14050063          	beqz	a0,80004ca0 <sys_unlink+0x1b0>
    80004b64:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b66:	f2c40613          	add	a2,s0,-212
    80004b6a:	fb040593          	add	a1,s0,-80
    80004b6e:	8526                	mv	a0,s1
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	62a080e7          	jalr	1578(ra) # 8000319a <dirlookup>
    80004b78:	892a                	mv	s2,a0
    80004b7a:	12050263          	beqz	a0,80004c9e <sys_unlink+0x1ae>
  ilock(ip);
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	110080e7          	jalr	272(ra) # 80002c8e <ilock>
  if(ip->nlink < 1)
    80004b86:	04a91783          	lh	a5,74(s2)
    80004b8a:	08f05563          	blez	a5,80004c14 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b8e:	04491703          	lh	a4,68(s2)
    80004b92:	4785                	li	a5,1
    80004b94:	08f70963          	beq	a4,a5,80004c26 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b98:	4641                	li	a2,16
    80004b9a:	4581                	li	a1,0
    80004b9c:	fc040513          	add	a0,s0,-64
    80004ba0:	ffffb097          	auipc	ra,0xffffb
    80004ba4:	624080e7          	jalr	1572(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba8:	4741                	li	a4,16
    80004baa:	f2c42683          	lw	a3,-212(s0)
    80004bae:	fc040613          	add	a2,s0,-64
    80004bb2:	4581                	li	a1,0
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	4a0080e7          	jalr	1184(ra) # 80003056 <writei>
    80004bbe:	47c1                	li	a5,16
    80004bc0:	0af51b63          	bne	a0,a5,80004c76 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004bc4:	04491703          	lh	a4,68(s2)
    80004bc8:	4785                	li	a5,1
    80004bca:	0af70f63          	beq	a4,a5,80004c88 <sys_unlink+0x198>
  iunlockput(dp);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	324080e7          	jalr	804(ra) # 80002ef4 <iunlockput>
  ip->nlink--;
    80004bd8:	04a95783          	lhu	a5,74(s2)
    80004bdc:	37fd                	addw	a5,a5,-1
    80004bde:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004be2:	854a                	mv	a0,s2
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	fde080e7          	jalr	-34(ra) # 80002bc2 <iupdate>
  iunlockput(ip);
    80004bec:	854a                	mv	a0,s2
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	306080e7          	jalr	774(ra) # 80002ef4 <iunlockput>
  end_op();
    80004bf6:	fffff097          	auipc	ra,0xfffff
    80004bfa:	ae0080e7          	jalr	-1312(ra) # 800036d6 <end_op>
  return 0;
    80004bfe:	4501                	li	a0,0
    80004c00:	64ee                	ld	s1,216(sp)
    80004c02:	694e                	ld	s2,208(sp)
    80004c04:	a84d                	j	80004cb6 <sys_unlink+0x1c6>
    end_op();
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	ad0080e7          	jalr	-1328(ra) # 800036d6 <end_op>
    return -1;
    80004c0e:	557d                	li	a0,-1
    80004c10:	64ee                	ld	s1,216(sp)
    80004c12:	a055                	j	80004cb6 <sys_unlink+0x1c6>
    80004c14:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004c16:	00004517          	auipc	a0,0x4
    80004c1a:	9b250513          	add	a0,a0,-1614 # 800085c8 <etext+0x5c8>
    80004c1e:	00001097          	auipc	ra,0x1
    80004c22:	244080e7          	jalr	580(ra) # 80005e62 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c26:	04c92703          	lw	a4,76(s2)
    80004c2a:	02000793          	li	a5,32
    80004c2e:	f6e7f5e3          	bgeu	a5,a4,80004b98 <sys_unlink+0xa8>
    80004c32:	e5ce                	sd	s3,200(sp)
    80004c34:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c38:	4741                	li	a4,16
    80004c3a:	86ce                	mv	a3,s3
    80004c3c:	f1840613          	add	a2,s0,-232
    80004c40:	4581                	li	a1,0
    80004c42:	854a                	mv	a0,s2
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	302080e7          	jalr	770(ra) # 80002f46 <readi>
    80004c4c:	47c1                	li	a5,16
    80004c4e:	00f51c63          	bne	a0,a5,80004c66 <sys_unlink+0x176>
    if(de.inum != 0)
    80004c52:	f1845783          	lhu	a5,-232(s0)
    80004c56:	e7b5                	bnez	a5,80004cc2 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c58:	29c1                	addw	s3,s3,16
    80004c5a:	04c92783          	lw	a5,76(s2)
    80004c5e:	fcf9ede3          	bltu	s3,a5,80004c38 <sys_unlink+0x148>
    80004c62:	69ae                	ld	s3,200(sp)
    80004c64:	bf15                	j	80004b98 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004c66:	00004517          	auipc	a0,0x4
    80004c6a:	97a50513          	add	a0,a0,-1670 # 800085e0 <etext+0x5e0>
    80004c6e:	00001097          	auipc	ra,0x1
    80004c72:	1f4080e7          	jalr	500(ra) # 80005e62 <panic>
    80004c76:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004c78:	00004517          	auipc	a0,0x4
    80004c7c:	98050513          	add	a0,a0,-1664 # 800085f8 <etext+0x5f8>
    80004c80:	00001097          	auipc	ra,0x1
    80004c84:	1e2080e7          	jalr	482(ra) # 80005e62 <panic>
    dp->nlink--;
    80004c88:	04a4d783          	lhu	a5,74(s1)
    80004c8c:	37fd                	addw	a5,a5,-1
    80004c8e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c92:	8526                	mv	a0,s1
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	f2e080e7          	jalr	-210(ra) # 80002bc2 <iupdate>
    80004c9c:	bf0d                	j	80004bce <sys_unlink+0xde>
    80004c9e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004ca0:	8526                	mv	a0,s1
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	252080e7          	jalr	594(ra) # 80002ef4 <iunlockput>
  end_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	a2c080e7          	jalr	-1492(ra) # 800036d6 <end_op>
  return -1;
    80004cb2:	557d                	li	a0,-1
    80004cb4:	64ee                	ld	s1,216(sp)
}
    80004cb6:	70ae                	ld	ra,232(sp)
    80004cb8:	740e                	ld	s0,224(sp)
    80004cba:	616d                	add	sp,sp,240
    80004cbc:	8082                	ret
    return -1;
    80004cbe:	557d                	li	a0,-1
    80004cc0:	bfdd                	j	80004cb6 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	230080e7          	jalr	560(ra) # 80002ef4 <iunlockput>
    goto bad;
    80004ccc:	694e                	ld	s2,208(sp)
    80004cce:	69ae                	ld	s3,200(sp)
    80004cd0:	bfc1                	j	80004ca0 <sys_unlink+0x1b0>

0000000080004cd2 <sys_open>:

uint64
sys_open(void)
{
    80004cd2:	7131                	add	sp,sp,-192
    80004cd4:	fd06                	sd	ra,184(sp)
    80004cd6:	f922                	sd	s0,176(sp)
    80004cd8:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cda:	f4c40593          	add	a1,s0,-180
    80004cde:	4505                	li	a0,1
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	416080e7          	jalr	1046(ra) # 800020f6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ce8:	08000613          	li	a2,128
    80004cec:	f5040593          	add	a1,s0,-176
    80004cf0:	4501                	li	a0,0
    80004cf2:	ffffd097          	auipc	ra,0xffffd
    80004cf6:	444080e7          	jalr	1092(ra) # 80002136 <argstr>
    80004cfa:	87aa                	mv	a5,a0
    return -1;
    80004cfc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cfe:	0a07ce63          	bltz	a5,80004dba <sys_open+0xe8>
    80004d02:	f526                	sd	s1,168(sp)

  begin_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	958080e7          	jalr	-1704(ra) # 8000365c <begin_op>

  if(omode & O_CREATE){
    80004d0c:	f4c42783          	lw	a5,-180(s0)
    80004d10:	2007f793          	and	a5,a5,512
    80004d14:	cfd5                	beqz	a5,80004dd0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d16:	4681                	li	a3,0
    80004d18:	4601                	li	a2,0
    80004d1a:	4589                	li	a1,2
    80004d1c:	f5040513          	add	a0,s0,-176
    80004d20:	00000097          	auipc	ra,0x0
    80004d24:	95c080e7          	jalr	-1700(ra) # 8000467c <create>
    80004d28:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d2a:	cd41                	beqz	a0,80004dc2 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d2c:	04449703          	lh	a4,68(s1)
    80004d30:	478d                	li	a5,3
    80004d32:	00f71763          	bne	a4,a5,80004d40 <sys_open+0x6e>
    80004d36:	0464d703          	lhu	a4,70(s1)
    80004d3a:	47a5                	li	a5,9
    80004d3c:	0ee7e163          	bltu	a5,a4,80004e1e <sys_open+0x14c>
    80004d40:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	d28080e7          	jalr	-728(ra) # 80003a6a <filealloc>
    80004d4a:	892a                	mv	s2,a0
    80004d4c:	c97d                	beqz	a0,80004e42 <sys_open+0x170>
    80004d4e:	ed4e                	sd	s3,152(sp)
    80004d50:	00000097          	auipc	ra,0x0
    80004d54:	8ea080e7          	jalr	-1814(ra) # 8000463a <fdalloc>
    80004d58:	89aa                	mv	s3,a0
    80004d5a:	0c054e63          	bltz	a0,80004e36 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d5e:	04449703          	lh	a4,68(s1)
    80004d62:	478d                	li	a5,3
    80004d64:	0ef70c63          	beq	a4,a5,80004e5c <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d68:	4789                	li	a5,2
    80004d6a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004d6e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004d72:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004d76:	f4c42783          	lw	a5,-180(s0)
    80004d7a:	0017c713          	xor	a4,a5,1
    80004d7e:	8b05                	and	a4,a4,1
    80004d80:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d84:	0037f713          	and	a4,a5,3
    80004d88:	00e03733          	snez	a4,a4
    80004d8c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d90:	4007f793          	and	a5,a5,1024
    80004d94:	c791                	beqz	a5,80004da0 <sys_open+0xce>
    80004d96:	04449703          	lh	a4,68(s1)
    80004d9a:	4789                	li	a5,2
    80004d9c:	0cf70763          	beq	a4,a5,80004e6a <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004da0:	8526                	mv	a0,s1
    80004da2:	ffffe097          	auipc	ra,0xffffe
    80004da6:	fb2080e7          	jalr	-78(ra) # 80002d54 <iunlock>
  end_op();
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	92c080e7          	jalr	-1748(ra) # 800036d6 <end_op>

  return fd;
    80004db2:	854e                	mv	a0,s3
    80004db4:	74aa                	ld	s1,168(sp)
    80004db6:	790a                	ld	s2,160(sp)
    80004db8:	69ea                	ld	s3,152(sp)
}
    80004dba:	70ea                	ld	ra,184(sp)
    80004dbc:	744a                	ld	s0,176(sp)
    80004dbe:	6129                	add	sp,sp,192
    80004dc0:	8082                	ret
      end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	914080e7          	jalr	-1772(ra) # 800036d6 <end_op>
      return -1;
    80004dca:	557d                	li	a0,-1
    80004dcc:	74aa                	ld	s1,168(sp)
    80004dce:	b7f5                	j	80004dba <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004dd0:	f5040513          	add	a0,s0,-176
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	688080e7          	jalr	1672(ra) # 8000345c <namei>
    80004ddc:	84aa                	mv	s1,a0
    80004dde:	c90d                	beqz	a0,80004e10 <sys_open+0x13e>
    ilock(ip);
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	eae080e7          	jalr	-338(ra) # 80002c8e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004de8:	04449703          	lh	a4,68(s1)
    80004dec:	4785                	li	a5,1
    80004dee:	f2f71fe3          	bne	a4,a5,80004d2c <sys_open+0x5a>
    80004df2:	f4c42783          	lw	a5,-180(s0)
    80004df6:	d7a9                	beqz	a5,80004d40 <sys_open+0x6e>
      iunlockput(ip);
    80004df8:	8526                	mv	a0,s1
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	0fa080e7          	jalr	250(ra) # 80002ef4 <iunlockput>
      end_op();
    80004e02:	fffff097          	auipc	ra,0xfffff
    80004e06:	8d4080e7          	jalr	-1836(ra) # 800036d6 <end_op>
      return -1;
    80004e0a:	557d                	li	a0,-1
    80004e0c:	74aa                	ld	s1,168(sp)
    80004e0e:	b775                	j	80004dba <sys_open+0xe8>
      end_op();
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	8c6080e7          	jalr	-1850(ra) # 800036d6 <end_op>
      return -1;
    80004e18:	557d                	li	a0,-1
    80004e1a:	74aa                	ld	s1,168(sp)
    80004e1c:	bf79                	j	80004dba <sys_open+0xe8>
    iunlockput(ip);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	0d4080e7          	jalr	212(ra) # 80002ef4 <iunlockput>
    end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	8ae080e7          	jalr	-1874(ra) # 800036d6 <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	74aa                	ld	s1,168(sp)
    80004e34:	b759                	j	80004dba <sys_open+0xe8>
      fileclose(f);
    80004e36:	854a                	mv	a0,s2
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	cee080e7          	jalr	-786(ra) # 80003b26 <fileclose>
    80004e40:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004e42:	8526                	mv	a0,s1
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	0b0080e7          	jalr	176(ra) # 80002ef4 <iunlockput>
    end_op();
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	88a080e7          	jalr	-1910(ra) # 800036d6 <end_op>
    return -1;
    80004e54:	557d                	li	a0,-1
    80004e56:	74aa                	ld	s1,168(sp)
    80004e58:	790a                	ld	s2,160(sp)
    80004e5a:	b785                	j	80004dba <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004e5c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004e60:	04649783          	lh	a5,70(s1)
    80004e64:	02f91223          	sh	a5,36(s2)
    80004e68:	b729                	j	80004d72 <sys_open+0xa0>
    itrunc(ip);
    80004e6a:	8526                	mv	a0,s1
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	f34080e7          	jalr	-204(ra) # 80002da0 <itrunc>
    80004e74:	b735                	j	80004da0 <sys_open+0xce>

0000000080004e76 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e76:	7175                	add	sp,sp,-144
    80004e78:	e506                	sd	ra,136(sp)
    80004e7a:	e122                	sd	s0,128(sp)
    80004e7c:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	7de080e7          	jalr	2014(ra) # 8000365c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e86:	08000613          	li	a2,128
    80004e8a:	f7040593          	add	a1,s0,-144
    80004e8e:	4501                	li	a0,0
    80004e90:	ffffd097          	auipc	ra,0xffffd
    80004e94:	2a6080e7          	jalr	678(ra) # 80002136 <argstr>
    80004e98:	02054963          	bltz	a0,80004eca <sys_mkdir+0x54>
    80004e9c:	4681                	li	a3,0
    80004e9e:	4601                	li	a2,0
    80004ea0:	4585                	li	a1,1
    80004ea2:	f7040513          	add	a0,s0,-144
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	7d6080e7          	jalr	2006(ra) # 8000467c <create>
    80004eae:	cd11                	beqz	a0,80004eca <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	044080e7          	jalr	68(ra) # 80002ef4 <iunlockput>
  end_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	81e080e7          	jalr	-2018(ra) # 800036d6 <end_op>
  return 0;
    80004ec0:	4501                	li	a0,0
}
    80004ec2:	60aa                	ld	ra,136(sp)
    80004ec4:	640a                	ld	s0,128(sp)
    80004ec6:	6149                	add	sp,sp,144
    80004ec8:	8082                	ret
    end_op();
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	80c080e7          	jalr	-2036(ra) # 800036d6 <end_op>
    return -1;
    80004ed2:	557d                	li	a0,-1
    80004ed4:	b7fd                	j	80004ec2 <sys_mkdir+0x4c>

0000000080004ed6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ed6:	7135                	add	sp,sp,-160
    80004ed8:	ed06                	sd	ra,152(sp)
    80004eda:	e922                	sd	s0,144(sp)
    80004edc:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ede:	ffffe097          	auipc	ra,0xffffe
    80004ee2:	77e080e7          	jalr	1918(ra) # 8000365c <begin_op>
  argint(1, &major);
    80004ee6:	f6c40593          	add	a1,s0,-148
    80004eea:	4505                	li	a0,1
    80004eec:	ffffd097          	auipc	ra,0xffffd
    80004ef0:	20a080e7          	jalr	522(ra) # 800020f6 <argint>
  argint(2, &minor);
    80004ef4:	f6840593          	add	a1,s0,-152
    80004ef8:	4509                	li	a0,2
    80004efa:	ffffd097          	auipc	ra,0xffffd
    80004efe:	1fc080e7          	jalr	508(ra) # 800020f6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f02:	08000613          	li	a2,128
    80004f06:	f7040593          	add	a1,s0,-144
    80004f0a:	4501                	li	a0,0
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	22a080e7          	jalr	554(ra) # 80002136 <argstr>
    80004f14:	02054b63          	bltz	a0,80004f4a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f18:	f6841683          	lh	a3,-152(s0)
    80004f1c:	f6c41603          	lh	a2,-148(s0)
    80004f20:	458d                	li	a1,3
    80004f22:	f7040513          	add	a0,s0,-144
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	756080e7          	jalr	1878(ra) # 8000467c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f2e:	cd11                	beqz	a0,80004f4a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	fc4080e7          	jalr	-60(ra) # 80002ef4 <iunlockput>
  end_op();
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	79e080e7          	jalr	1950(ra) # 800036d6 <end_op>
  return 0;
    80004f40:	4501                	li	a0,0
}
    80004f42:	60ea                	ld	ra,152(sp)
    80004f44:	644a                	ld	s0,144(sp)
    80004f46:	610d                	add	sp,sp,160
    80004f48:	8082                	ret
    end_op();
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	78c080e7          	jalr	1932(ra) # 800036d6 <end_op>
    return -1;
    80004f52:	557d                	li	a0,-1
    80004f54:	b7fd                	j	80004f42 <sys_mknod+0x6c>

0000000080004f56 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f56:	7135                	add	sp,sp,-160
    80004f58:	ed06                	sd	ra,152(sp)
    80004f5a:	e922                	sd	s0,144(sp)
    80004f5c:	e14a                	sd	s2,128(sp)
    80004f5e:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f60:	ffffc097          	auipc	ra,0xffffc
    80004f64:	ff0080e7          	jalr	-16(ra) # 80000f50 <myproc>
    80004f68:	892a                	mv	s2,a0
  
  begin_op();
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	6f2080e7          	jalr	1778(ra) # 8000365c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f72:	08000613          	li	a2,128
    80004f76:	f6040593          	add	a1,s0,-160
    80004f7a:	4501                	li	a0,0
    80004f7c:	ffffd097          	auipc	ra,0xffffd
    80004f80:	1ba080e7          	jalr	442(ra) # 80002136 <argstr>
    80004f84:	04054d63          	bltz	a0,80004fde <sys_chdir+0x88>
    80004f88:	e526                	sd	s1,136(sp)
    80004f8a:	f6040513          	add	a0,s0,-160
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	4ce080e7          	jalr	1230(ra) # 8000345c <namei>
    80004f96:	84aa                	mv	s1,a0
    80004f98:	c131                	beqz	a0,80004fdc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	cf4080e7          	jalr	-780(ra) # 80002c8e <ilock>
  if(ip->type != T_DIR){
    80004fa2:	04449703          	lh	a4,68(s1)
    80004fa6:	4785                	li	a5,1
    80004fa8:	04f71163          	bne	a4,a5,80004fea <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fac:	8526                	mv	a0,s1
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	da6080e7          	jalr	-602(ra) # 80002d54 <iunlock>
  iput(p->cwd);
    80004fb6:	15093503          	ld	a0,336(s2)
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	e92080e7          	jalr	-366(ra) # 80002e4c <iput>
  end_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	714080e7          	jalr	1812(ra) # 800036d6 <end_op>
  p->cwd = ip;
    80004fca:	14993823          	sd	s1,336(s2)
  return 0;
    80004fce:	4501                	li	a0,0
    80004fd0:	64aa                	ld	s1,136(sp)
}
    80004fd2:	60ea                	ld	ra,152(sp)
    80004fd4:	644a                	ld	s0,144(sp)
    80004fd6:	690a                	ld	s2,128(sp)
    80004fd8:	610d                	add	sp,sp,160
    80004fda:	8082                	ret
    80004fdc:	64aa                	ld	s1,136(sp)
    end_op();
    80004fde:	ffffe097          	auipc	ra,0xffffe
    80004fe2:	6f8080e7          	jalr	1784(ra) # 800036d6 <end_op>
    return -1;
    80004fe6:	557d                	li	a0,-1
    80004fe8:	b7ed                	j	80004fd2 <sys_chdir+0x7c>
    iunlockput(ip);
    80004fea:	8526                	mv	a0,s1
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	f08080e7          	jalr	-248(ra) # 80002ef4 <iunlockput>
    end_op();
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	6e2080e7          	jalr	1762(ra) # 800036d6 <end_op>
    return -1;
    80004ffc:	557d                	li	a0,-1
    80004ffe:	64aa                	ld	s1,136(sp)
    80005000:	bfc9                	j	80004fd2 <sys_chdir+0x7c>

0000000080005002 <sys_exec>:

uint64
sys_exec(void)
{
    80005002:	7121                	add	sp,sp,-448
    80005004:	ff06                	sd	ra,440(sp)
    80005006:	fb22                	sd	s0,432(sp)
    80005008:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000500a:	e4840593          	add	a1,s0,-440
    8000500e:	4505                	li	a0,1
    80005010:	ffffd097          	auipc	ra,0xffffd
    80005014:	106080e7          	jalr	262(ra) # 80002116 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005018:	08000613          	li	a2,128
    8000501c:	f5040593          	add	a1,s0,-176
    80005020:	4501                	li	a0,0
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	114080e7          	jalr	276(ra) # 80002136 <argstr>
    8000502a:	87aa                	mv	a5,a0
    return -1;
    8000502c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000502e:	0e07c263          	bltz	a5,80005112 <sys_exec+0x110>
    80005032:	f726                	sd	s1,424(sp)
    80005034:	f34a                	sd	s2,416(sp)
    80005036:	ef4e                	sd	s3,408(sp)
    80005038:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000503a:	10000613          	li	a2,256
    8000503e:	4581                	li	a1,0
    80005040:	e5040513          	add	a0,s0,-432
    80005044:	ffffb097          	auipc	ra,0xffffb
    80005048:	180080e7          	jalr	384(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000504c:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005050:	89a6                	mv	s3,s1
    80005052:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005054:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005058:	00391513          	sll	a0,s2,0x3
    8000505c:	e4040593          	add	a1,s0,-448
    80005060:	e4843783          	ld	a5,-440(s0)
    80005064:	953e                	add	a0,a0,a5
    80005066:	ffffd097          	auipc	ra,0xffffd
    8000506a:	ff2080e7          	jalr	-14(ra) # 80002058 <fetchaddr>
    8000506e:	02054a63          	bltz	a0,800050a2 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005072:	e4043783          	ld	a5,-448(s0)
    80005076:	c7b9                	beqz	a5,800050c4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005078:	ffffb097          	auipc	ra,0xffffb
    8000507c:	0a2080e7          	jalr	162(ra) # 8000011a <kalloc>
    80005080:	85aa                	mv	a1,a0
    80005082:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005086:	cd11                	beqz	a0,800050a2 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005088:	6605                	lui	a2,0x1
    8000508a:	e4043503          	ld	a0,-448(s0)
    8000508e:	ffffd097          	auipc	ra,0xffffd
    80005092:	01c080e7          	jalr	28(ra) # 800020aa <fetchstr>
    80005096:	00054663          	bltz	a0,800050a2 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000509a:	0905                	add	s2,s2,1
    8000509c:	09a1                	add	s3,s3,8
    8000509e:	fb491de3          	bne	s2,s4,80005058 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a2:	f5040913          	add	s2,s0,-176
    800050a6:	6088                	ld	a0,0(s1)
    800050a8:	c125                	beqz	a0,80005108 <sys_exec+0x106>
    kfree(argv[i]);
    800050aa:	ffffb097          	auipc	ra,0xffffb
    800050ae:	f72080e7          	jalr	-142(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b2:	04a1                	add	s1,s1,8
    800050b4:	ff2499e3          	bne	s1,s2,800050a6 <sys_exec+0xa4>
  return -1;
    800050b8:	557d                	li	a0,-1
    800050ba:	74ba                	ld	s1,424(sp)
    800050bc:	791a                	ld	s2,416(sp)
    800050be:	69fa                	ld	s3,408(sp)
    800050c0:	6a5a                	ld	s4,400(sp)
    800050c2:	a881                	j	80005112 <sys_exec+0x110>
      argv[i] = 0;
    800050c4:	0009079b          	sext.w	a5,s2
    800050c8:	078e                	sll	a5,a5,0x3
    800050ca:	fd078793          	add	a5,a5,-48
    800050ce:	97a2                	add	a5,a5,s0
    800050d0:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050d4:	e5040593          	add	a1,s0,-432
    800050d8:	f5040513          	add	a0,s0,-176
    800050dc:	fffff097          	auipc	ra,0xfffff
    800050e0:	120080e7          	jalr	288(ra) # 800041fc <exec>
    800050e4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e6:	f5040993          	add	s3,s0,-176
    800050ea:	6088                	ld	a0,0(s1)
    800050ec:	c901                	beqz	a0,800050fc <sys_exec+0xfa>
    kfree(argv[i]);
    800050ee:	ffffb097          	auipc	ra,0xffffb
    800050f2:	f2e080e7          	jalr	-210(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f6:	04a1                	add	s1,s1,8
    800050f8:	ff3499e3          	bne	s1,s3,800050ea <sys_exec+0xe8>
  return ret;
    800050fc:	854a                	mv	a0,s2
    800050fe:	74ba                	ld	s1,424(sp)
    80005100:	791a                	ld	s2,416(sp)
    80005102:	69fa                	ld	s3,408(sp)
    80005104:	6a5a                	ld	s4,400(sp)
    80005106:	a031                	j	80005112 <sys_exec+0x110>
  return -1;
    80005108:	557d                	li	a0,-1
    8000510a:	74ba                	ld	s1,424(sp)
    8000510c:	791a                	ld	s2,416(sp)
    8000510e:	69fa                	ld	s3,408(sp)
    80005110:	6a5a                	ld	s4,400(sp)
}
    80005112:	70fa                	ld	ra,440(sp)
    80005114:	745a                	ld	s0,432(sp)
    80005116:	6139                	add	sp,sp,448
    80005118:	8082                	ret

000000008000511a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000511a:	7139                	add	sp,sp,-64
    8000511c:	fc06                	sd	ra,56(sp)
    8000511e:	f822                	sd	s0,48(sp)
    80005120:	f426                	sd	s1,40(sp)
    80005122:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005124:	ffffc097          	auipc	ra,0xffffc
    80005128:	e2c080e7          	jalr	-468(ra) # 80000f50 <myproc>
    8000512c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000512e:	fd840593          	add	a1,s0,-40
    80005132:	4501                	li	a0,0
    80005134:	ffffd097          	auipc	ra,0xffffd
    80005138:	fe2080e7          	jalr	-30(ra) # 80002116 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000513c:	fc840593          	add	a1,s0,-56
    80005140:	fd040513          	add	a0,s0,-48
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	d50080e7          	jalr	-688(ra) # 80003e94 <pipealloc>
    return -1;
    8000514c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000514e:	0c054463          	bltz	a0,80005216 <sys_pipe+0xfc>
  fd0 = -1;
    80005152:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005156:	fd043503          	ld	a0,-48(s0)
    8000515a:	fffff097          	auipc	ra,0xfffff
    8000515e:	4e0080e7          	jalr	1248(ra) # 8000463a <fdalloc>
    80005162:	fca42223          	sw	a0,-60(s0)
    80005166:	08054b63          	bltz	a0,800051fc <sys_pipe+0xe2>
    8000516a:	fc843503          	ld	a0,-56(s0)
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	4cc080e7          	jalr	1228(ra) # 8000463a <fdalloc>
    80005176:	fca42023          	sw	a0,-64(s0)
    8000517a:	06054863          	bltz	a0,800051ea <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000517e:	4691                	li	a3,4
    80005180:	fc440613          	add	a2,s0,-60
    80005184:	fd843583          	ld	a1,-40(s0)
    80005188:	68a8                	ld	a0,80(s1)
    8000518a:	ffffc097          	auipc	ra,0xffffc
    8000518e:	a0c080e7          	jalr	-1524(ra) # 80000b96 <copyout>
    80005192:	02054063          	bltz	a0,800051b2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005196:	4691                	li	a3,4
    80005198:	fc040613          	add	a2,s0,-64
    8000519c:	fd843583          	ld	a1,-40(s0)
    800051a0:	0591                	add	a1,a1,4
    800051a2:	68a8                	ld	a0,80(s1)
    800051a4:	ffffc097          	auipc	ra,0xffffc
    800051a8:	9f2080e7          	jalr	-1550(ra) # 80000b96 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051ac:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051ae:	06055463          	bgez	a0,80005216 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051b2:	fc442783          	lw	a5,-60(s0)
    800051b6:	07e9                	add	a5,a5,26
    800051b8:	078e                	sll	a5,a5,0x3
    800051ba:	97a6                	add	a5,a5,s1
    800051bc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051c0:	fc042783          	lw	a5,-64(s0)
    800051c4:	07e9                	add	a5,a5,26
    800051c6:	078e                	sll	a5,a5,0x3
    800051c8:	94be                	add	s1,s1,a5
    800051ca:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051ce:	fd043503          	ld	a0,-48(s0)
    800051d2:	fffff097          	auipc	ra,0xfffff
    800051d6:	954080e7          	jalr	-1708(ra) # 80003b26 <fileclose>
    fileclose(wf);
    800051da:	fc843503          	ld	a0,-56(s0)
    800051de:	fffff097          	auipc	ra,0xfffff
    800051e2:	948080e7          	jalr	-1720(ra) # 80003b26 <fileclose>
    return -1;
    800051e6:	57fd                	li	a5,-1
    800051e8:	a03d                	j	80005216 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051ea:	fc442783          	lw	a5,-60(s0)
    800051ee:	0007c763          	bltz	a5,800051fc <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051f2:	07e9                	add	a5,a5,26
    800051f4:	078e                	sll	a5,a5,0x3
    800051f6:	97a6                	add	a5,a5,s1
    800051f8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051fc:	fd043503          	ld	a0,-48(s0)
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	926080e7          	jalr	-1754(ra) # 80003b26 <fileclose>
    fileclose(wf);
    80005208:	fc843503          	ld	a0,-56(s0)
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	91a080e7          	jalr	-1766(ra) # 80003b26 <fileclose>
    return -1;
    80005214:	57fd                	li	a5,-1
}
    80005216:	853e                	mv	a0,a5
    80005218:	70e2                	ld	ra,56(sp)
    8000521a:	7442                	ld	s0,48(sp)
    8000521c:	74a2                	ld	s1,40(sp)
    8000521e:	6121                	add	sp,sp,64
    80005220:	8082                	ret
	...

0000000080005230 <kernelvec>:
    80005230:	7111                	add	sp,sp,-256
    80005232:	e006                	sd	ra,0(sp)
    80005234:	e40a                	sd	sp,8(sp)
    80005236:	e80e                	sd	gp,16(sp)
    80005238:	ec12                	sd	tp,24(sp)
    8000523a:	f016                	sd	t0,32(sp)
    8000523c:	f41a                	sd	t1,40(sp)
    8000523e:	f81e                	sd	t2,48(sp)
    80005240:	fc22                	sd	s0,56(sp)
    80005242:	e0a6                	sd	s1,64(sp)
    80005244:	e4aa                	sd	a0,72(sp)
    80005246:	e8ae                	sd	a1,80(sp)
    80005248:	ecb2                	sd	a2,88(sp)
    8000524a:	f0b6                	sd	a3,96(sp)
    8000524c:	f4ba                	sd	a4,104(sp)
    8000524e:	f8be                	sd	a5,112(sp)
    80005250:	fcc2                	sd	a6,120(sp)
    80005252:	e146                	sd	a7,128(sp)
    80005254:	e54a                	sd	s2,136(sp)
    80005256:	e94e                	sd	s3,144(sp)
    80005258:	ed52                	sd	s4,152(sp)
    8000525a:	f156                	sd	s5,160(sp)
    8000525c:	f55a                	sd	s6,168(sp)
    8000525e:	f95e                	sd	s7,176(sp)
    80005260:	fd62                	sd	s8,184(sp)
    80005262:	e1e6                	sd	s9,192(sp)
    80005264:	e5ea                	sd	s10,200(sp)
    80005266:	e9ee                	sd	s11,208(sp)
    80005268:	edf2                	sd	t3,216(sp)
    8000526a:	f1f6                	sd	t4,224(sp)
    8000526c:	f5fa                	sd	t5,232(sp)
    8000526e:	f9fe                	sd	t6,240(sp)
    80005270:	cb5fc0ef          	jal	80001f24 <kerneltrap>
    80005274:	6082                	ld	ra,0(sp)
    80005276:	6122                	ld	sp,8(sp)
    80005278:	61c2                	ld	gp,16(sp)
    8000527a:	7282                	ld	t0,32(sp)
    8000527c:	7322                	ld	t1,40(sp)
    8000527e:	73c2                	ld	t2,48(sp)
    80005280:	7462                	ld	s0,56(sp)
    80005282:	6486                	ld	s1,64(sp)
    80005284:	6526                	ld	a0,72(sp)
    80005286:	65c6                	ld	a1,80(sp)
    80005288:	6666                	ld	a2,88(sp)
    8000528a:	7686                	ld	a3,96(sp)
    8000528c:	7726                	ld	a4,104(sp)
    8000528e:	77c6                	ld	a5,112(sp)
    80005290:	7866                	ld	a6,120(sp)
    80005292:	688a                	ld	a7,128(sp)
    80005294:	692a                	ld	s2,136(sp)
    80005296:	69ca                	ld	s3,144(sp)
    80005298:	6a6a                	ld	s4,152(sp)
    8000529a:	7a8a                	ld	s5,160(sp)
    8000529c:	7b2a                	ld	s6,168(sp)
    8000529e:	7bca                	ld	s7,176(sp)
    800052a0:	7c6a                	ld	s8,184(sp)
    800052a2:	6c8e                	ld	s9,192(sp)
    800052a4:	6d2e                	ld	s10,200(sp)
    800052a6:	6dce                	ld	s11,208(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	add	sp,sp,256
    800052b2:	10200073          	sret
    800052b6:	00000013          	nop
    800052ba:	00000013          	nop
    800052be:	0001                	nop

00000000800052c0 <timervec>:
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	e10c                	sd	a1,0(a0)
    800052c6:	e510                	sd	a2,8(a0)
    800052c8:	e914                	sd	a3,16(a0)
    800052ca:	6d0c                	ld	a1,24(a0)
    800052cc:	7110                	ld	a2,32(a0)
    800052ce:	6194                	ld	a3,0(a1)
    800052d0:	96b2                	add	a3,a3,a2
    800052d2:	e194                	sd	a3,0(a1)
    800052d4:	4589                	li	a1,2
    800052d6:	14459073          	csrw	sip,a1
    800052da:	6914                	ld	a3,16(a0)
    800052dc:	6510                	ld	a2,8(a0)
    800052de:	610c                	ld	a1,0(a0)
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	30200073          	mret
	...

00000000800052ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ea:	1141                	add	sp,sp,-16
    800052ec:	e422                	sd	s0,8(sp)
    800052ee:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052f0:	0c0007b7          	lui	a5,0xc000
    800052f4:	4705                	li	a4,1
    800052f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052f8:	0c0007b7          	lui	a5,0xc000
    800052fc:	c3d8                	sw	a4,4(a5)
}
    800052fe:	6422                	ld	s0,8(sp)
    80005300:	0141                	add	sp,sp,16
    80005302:	8082                	ret

0000000080005304 <plicinithart>:

void
plicinithart(void)
{
    80005304:	1141                	add	sp,sp,-16
    80005306:	e406                	sd	ra,8(sp)
    80005308:	e022                	sd	s0,0(sp)
    8000530a:	0800                	add	s0,sp,16
  int hart = cpuid();
    8000530c:	ffffc097          	auipc	ra,0xffffc
    80005310:	c18080e7          	jalr	-1000(ra) # 80000f24 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005314:	0085171b          	sllw	a4,a0,0x8
    80005318:	0c0027b7          	lui	a5,0xc002
    8000531c:	97ba                	add	a5,a5,a4
    8000531e:	40200713          	li	a4,1026
    80005322:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005326:	00d5151b          	sllw	a0,a0,0xd
    8000532a:	0c2017b7          	lui	a5,0xc201
    8000532e:	97aa                	add	a5,a5,a0
    80005330:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005334:	60a2                	ld	ra,8(sp)
    80005336:	6402                	ld	s0,0(sp)
    80005338:	0141                	add	sp,sp,16
    8000533a:	8082                	ret

000000008000533c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000533c:	1141                	add	sp,sp,-16
    8000533e:	e406                	sd	ra,8(sp)
    80005340:	e022                	sd	s0,0(sp)
    80005342:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005344:	ffffc097          	auipc	ra,0xffffc
    80005348:	be0080e7          	jalr	-1056(ra) # 80000f24 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000534c:	00d5151b          	sllw	a0,a0,0xd
    80005350:	0c2017b7          	lui	a5,0xc201
    80005354:	97aa                	add	a5,a5,a0
  return irq;
}
    80005356:	43c8                	lw	a0,4(a5)
    80005358:	60a2                	ld	ra,8(sp)
    8000535a:	6402                	ld	s0,0(sp)
    8000535c:	0141                	add	sp,sp,16
    8000535e:	8082                	ret

0000000080005360 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005360:	1101                	add	sp,sp,-32
    80005362:	ec06                	sd	ra,24(sp)
    80005364:	e822                	sd	s0,16(sp)
    80005366:	e426                	sd	s1,8(sp)
    80005368:	1000                	add	s0,sp,32
    8000536a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000536c:	ffffc097          	auipc	ra,0xffffc
    80005370:	bb8080e7          	jalr	-1096(ra) # 80000f24 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005374:	00d5151b          	sllw	a0,a0,0xd
    80005378:	0c2017b7          	lui	a5,0xc201
    8000537c:	97aa                	add	a5,a5,a0
    8000537e:	c3c4                	sw	s1,4(a5)
}
    80005380:	60e2                	ld	ra,24(sp)
    80005382:	6442                	ld	s0,16(sp)
    80005384:	64a2                	ld	s1,8(sp)
    80005386:	6105                	add	sp,sp,32
    80005388:	8082                	ret

000000008000538a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000538a:	1141                	add	sp,sp,-16
    8000538c:	e406                	sd	ra,8(sp)
    8000538e:	e022                	sd	s0,0(sp)
    80005390:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005392:	479d                	li	a5,7
    80005394:	04a7cc63          	blt	a5,a0,800053ec <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005398:	00014797          	auipc	a5,0x14
    8000539c:	66878793          	add	a5,a5,1640 # 80019a00 <disk>
    800053a0:	97aa                	add	a5,a5,a0
    800053a2:	0187c783          	lbu	a5,24(a5)
    800053a6:	ebb9                	bnez	a5,800053fc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053a8:	00451693          	sll	a3,a0,0x4
    800053ac:	00014797          	auipc	a5,0x14
    800053b0:	65478793          	add	a5,a5,1620 # 80019a00 <disk>
    800053b4:	6398                	ld	a4,0(a5)
    800053b6:	9736                	add	a4,a4,a3
    800053b8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800053bc:	6398                	ld	a4,0(a5)
    800053be:	9736                	add	a4,a4,a3
    800053c0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053c4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053c8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053cc:	97aa                	add	a5,a5,a0
    800053ce:	4705                	li	a4,1
    800053d0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053d4:	00014517          	auipc	a0,0x14
    800053d8:	64450513          	add	a0,a0,1604 # 80019a18 <disk+0x18>
    800053dc:	ffffc097          	auipc	ra,0xffffc
    800053e0:	286080e7          	jalr	646(ra) # 80001662 <wakeup>
}
    800053e4:	60a2                	ld	ra,8(sp)
    800053e6:	6402                	ld	s0,0(sp)
    800053e8:	0141                	add	sp,sp,16
    800053ea:	8082                	ret
    panic("free_desc 1");
    800053ec:	00003517          	auipc	a0,0x3
    800053f0:	21c50513          	add	a0,a0,540 # 80008608 <etext+0x608>
    800053f4:	00001097          	auipc	ra,0x1
    800053f8:	a6e080e7          	jalr	-1426(ra) # 80005e62 <panic>
    panic("free_desc 2");
    800053fc:	00003517          	auipc	a0,0x3
    80005400:	21c50513          	add	a0,a0,540 # 80008618 <etext+0x618>
    80005404:	00001097          	auipc	ra,0x1
    80005408:	a5e080e7          	jalr	-1442(ra) # 80005e62 <panic>

000000008000540c <virtio_disk_init>:
{
    8000540c:	1101                	add	sp,sp,-32
    8000540e:	ec06                	sd	ra,24(sp)
    80005410:	e822                	sd	s0,16(sp)
    80005412:	e426                	sd	s1,8(sp)
    80005414:	e04a                	sd	s2,0(sp)
    80005416:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005418:	00003597          	auipc	a1,0x3
    8000541c:	21058593          	add	a1,a1,528 # 80008628 <etext+0x628>
    80005420:	00014517          	auipc	a0,0x14
    80005424:	70850513          	add	a0,a0,1800 # 80019b28 <disk+0x128>
    80005428:	00001097          	auipc	ra,0x1
    8000542c:	f24080e7          	jalr	-220(ra) # 8000634c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005430:	100017b7          	lui	a5,0x10001
    80005434:	4398                	lw	a4,0(a5)
    80005436:	2701                	sext.w	a4,a4
    80005438:	747277b7          	lui	a5,0x74727
    8000543c:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005440:	18f71c63          	bne	a4,a5,800055d8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000544a:	439c                	lw	a5,0(a5)
    8000544c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000544e:	4709                	li	a4,2
    80005450:	18e79463          	bne	a5,a4,800055d8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005454:	100017b7          	lui	a5,0x10001
    80005458:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000545a:	439c                	lw	a5,0(a5)
    8000545c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000545e:	16e79d63          	bne	a5,a4,800055d8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005462:	100017b7          	lui	a5,0x10001
    80005466:	47d8                	lw	a4,12(a5)
    80005468:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546a:	554d47b7          	lui	a5,0x554d4
    8000546e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005472:	16f71363          	bne	a4,a5,800055d8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005476:	100017b7          	lui	a5,0x10001
    8000547a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547e:	4705                	li	a4,1
    80005480:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005482:	470d                	li	a4,3
    80005484:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005486:	10001737          	lui	a4,0x10001
    8000548a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000548c:	c7ffe737          	lui	a4,0xc7ffe
    80005490:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9df>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005494:	8ef9                	and	a3,a3,a4
    80005496:	10001737          	lui	a4,0x10001
    8000549a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549c:	472d                	li	a4,11
    8000549e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a0:	07078793          	add	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800054a4:	439c                	lw	a5,0(a5)
    800054a6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054aa:	8ba1                	and	a5,a5,8
    800054ac:	12078e63          	beqz	a5,800055e8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054b0:	100017b7          	lui	a5,0x10001
    800054b4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054b8:	100017b7          	lui	a5,0x10001
    800054bc:	04478793          	add	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800054c0:	439c                	lw	a5,0(a5)
    800054c2:	2781                	sext.w	a5,a5
    800054c4:	12079a63          	bnez	a5,800055f8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054c8:	100017b7          	lui	a5,0x10001
    800054cc:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800054d0:	439c                	lw	a5,0(a5)
    800054d2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054d4:	12078a63          	beqz	a5,80005608 <virtio_disk_init+0x1fc>
  if(max < NUM)
    800054d8:	471d                	li	a4,7
    800054da:	12f77f63          	bgeu	a4,a5,80005618 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800054de:	ffffb097          	auipc	ra,0xffffb
    800054e2:	c3c080e7          	jalr	-964(ra) # 8000011a <kalloc>
    800054e6:	00014497          	auipc	s1,0x14
    800054ea:	51a48493          	add	s1,s1,1306 # 80019a00 <disk>
    800054ee:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054f0:	ffffb097          	auipc	ra,0xffffb
    800054f4:	c2a080e7          	jalr	-982(ra) # 8000011a <kalloc>
    800054f8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054fa:	ffffb097          	auipc	ra,0xffffb
    800054fe:	c20080e7          	jalr	-992(ra) # 8000011a <kalloc>
    80005502:	87aa                	mv	a5,a0
    80005504:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005506:	6088                	ld	a0,0(s1)
    80005508:	12050063          	beqz	a0,80005628 <virtio_disk_init+0x21c>
    8000550c:	00014717          	auipc	a4,0x14
    80005510:	4fc73703          	ld	a4,1276(a4) # 80019a08 <disk+0x8>
    80005514:	10070a63          	beqz	a4,80005628 <virtio_disk_init+0x21c>
    80005518:	10078863          	beqz	a5,80005628 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000551c:	6605                	lui	a2,0x1
    8000551e:	4581                	li	a1,0
    80005520:	ffffb097          	auipc	ra,0xffffb
    80005524:	ca4080e7          	jalr	-860(ra) # 800001c4 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005528:	00014497          	auipc	s1,0x14
    8000552c:	4d848493          	add	s1,s1,1240 # 80019a00 <disk>
    80005530:	6605                	lui	a2,0x1
    80005532:	4581                	li	a1,0
    80005534:	6488                	ld	a0,8(s1)
    80005536:	ffffb097          	auipc	ra,0xffffb
    8000553a:	c8e080e7          	jalr	-882(ra) # 800001c4 <memset>
  memset(disk.used, 0, PGSIZE);
    8000553e:	6605                	lui	a2,0x1
    80005540:	4581                	li	a1,0
    80005542:	6888                	ld	a0,16(s1)
    80005544:	ffffb097          	auipc	ra,0xffffb
    80005548:	c80080e7          	jalr	-896(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000554c:	100017b7          	lui	a5,0x10001
    80005550:	4721                	li	a4,8
    80005552:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005554:	4098                	lw	a4,0(s1)
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000555e:	40d8                	lw	a4,4(s1)
    80005560:	100017b7          	lui	a5,0x10001
    80005564:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005568:	649c                	ld	a5,8(s1)
    8000556a:	0007869b          	sext.w	a3,a5
    8000556e:	10001737          	lui	a4,0x10001
    80005572:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005576:	9781                	sra	a5,a5,0x20
    80005578:	10001737          	lui	a4,0x10001
    8000557c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005580:	689c                	ld	a5,16(s1)
    80005582:	0007869b          	sext.w	a3,a5
    80005586:	10001737          	lui	a4,0x10001
    8000558a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000558e:	9781                	sra	a5,a5,0x20
    80005590:	10001737          	lui	a4,0x10001
    80005594:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005598:	10001737          	lui	a4,0x10001
    8000559c:	4785                	li	a5,1
    8000559e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800055a0:	00f48c23          	sb	a5,24(s1)
    800055a4:	00f48ca3          	sb	a5,25(s1)
    800055a8:	00f48d23          	sb	a5,26(s1)
    800055ac:	00f48da3          	sb	a5,27(s1)
    800055b0:	00f48e23          	sb	a5,28(s1)
    800055b4:	00f48ea3          	sb	a5,29(s1)
    800055b8:	00f48f23          	sb	a5,30(s1)
    800055bc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055c0:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c4:	100017b7          	lui	a5,0x10001
    800055c8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800055cc:	60e2                	ld	ra,24(sp)
    800055ce:	6442                	ld	s0,16(sp)
    800055d0:	64a2                	ld	s1,8(sp)
    800055d2:	6902                	ld	s2,0(sp)
    800055d4:	6105                	add	sp,sp,32
    800055d6:	8082                	ret
    panic("could not find virtio disk");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	06050513          	add	a0,a0,96 # 80008638 <etext+0x638>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	882080e7          	jalr	-1918(ra) # 80005e62 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	07050513          	add	a0,a0,112 # 80008658 <etext+0x658>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	872080e7          	jalr	-1934(ra) # 80005e62 <panic>
    panic("virtio disk should not be ready");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	08050513          	add	a0,a0,128 # 80008678 <etext+0x678>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	862080e7          	jalr	-1950(ra) # 80005e62 <panic>
    panic("virtio disk has no queue 0");
    80005608:	00003517          	auipc	a0,0x3
    8000560c:	09050513          	add	a0,a0,144 # 80008698 <etext+0x698>
    80005610:	00001097          	auipc	ra,0x1
    80005614:	852080e7          	jalr	-1966(ra) # 80005e62 <panic>
    panic("virtio disk max queue too short");
    80005618:	00003517          	auipc	a0,0x3
    8000561c:	0a050513          	add	a0,a0,160 # 800086b8 <etext+0x6b8>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	842080e7          	jalr	-1982(ra) # 80005e62 <panic>
    panic("virtio disk kalloc");
    80005628:	00003517          	auipc	a0,0x3
    8000562c:	0b050513          	add	a0,a0,176 # 800086d8 <etext+0x6d8>
    80005630:	00001097          	auipc	ra,0x1
    80005634:	832080e7          	jalr	-1998(ra) # 80005e62 <panic>

0000000080005638 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005638:	7159                	add	sp,sp,-112
    8000563a:	f486                	sd	ra,104(sp)
    8000563c:	f0a2                	sd	s0,96(sp)
    8000563e:	eca6                	sd	s1,88(sp)
    80005640:	e8ca                	sd	s2,80(sp)
    80005642:	e4ce                	sd	s3,72(sp)
    80005644:	e0d2                	sd	s4,64(sp)
    80005646:	fc56                	sd	s5,56(sp)
    80005648:	f85a                	sd	s6,48(sp)
    8000564a:	f45e                	sd	s7,40(sp)
    8000564c:	f062                	sd	s8,32(sp)
    8000564e:	ec66                	sd	s9,24(sp)
    80005650:	1880                	add	s0,sp,112
    80005652:	8a2a                	mv	s4,a0
    80005654:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005656:	00c52c83          	lw	s9,12(a0)
    8000565a:	001c9c9b          	sllw	s9,s9,0x1
    8000565e:	1c82                	sll	s9,s9,0x20
    80005660:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005664:	00014517          	auipc	a0,0x14
    80005668:	4c450513          	add	a0,a0,1220 # 80019b28 <disk+0x128>
    8000566c:	00001097          	auipc	ra,0x1
    80005670:	d70080e7          	jalr	-656(ra) # 800063dc <acquire>
  for(int i = 0; i < 3; i++){
    80005674:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005676:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005678:	00014b17          	auipc	s6,0x14
    8000567c:	388b0b13          	add	s6,s6,904 # 80019a00 <disk>
  for(int i = 0; i < 3; i++){
    80005680:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005682:	00014c17          	auipc	s8,0x14
    80005686:	4a6c0c13          	add	s8,s8,1190 # 80019b28 <disk+0x128>
    8000568a:	a0ad                	j	800056f4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000568c:	00fb0733          	add	a4,s6,a5
    80005690:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005694:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005696:	0207c563          	bltz	a5,800056c0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000569a:	2905                	addw	s2,s2,1
    8000569c:	0611                	add	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000569e:	05590f63          	beq	s2,s5,800056fc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800056a2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056a4:	00014717          	auipc	a4,0x14
    800056a8:	35c70713          	add	a4,a4,860 # 80019a00 <disk>
    800056ac:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056ae:	01874683          	lbu	a3,24(a4)
    800056b2:	fee9                	bnez	a3,8000568c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800056b4:	2785                	addw	a5,a5,1
    800056b6:	0705                	add	a4,a4,1
    800056b8:	fe979be3          	bne	a5,s1,800056ae <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800056bc:	57fd                	li	a5,-1
    800056be:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056c0:	03205163          	blez	s2,800056e2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800056c4:	f9042503          	lw	a0,-112(s0)
    800056c8:	00000097          	auipc	ra,0x0
    800056cc:	cc2080e7          	jalr	-830(ra) # 8000538a <free_desc>
      for(int j = 0; j < i; j++)
    800056d0:	4785                	li	a5,1
    800056d2:	0127d863          	bge	a5,s2,800056e2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800056d6:	f9442503          	lw	a0,-108(s0)
    800056da:	00000097          	auipc	ra,0x0
    800056de:	cb0080e7          	jalr	-848(ra) # 8000538a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056e2:	85e2                	mv	a1,s8
    800056e4:	00014517          	auipc	a0,0x14
    800056e8:	33450513          	add	a0,a0,820 # 80019a18 <disk+0x18>
    800056ec:	ffffc097          	auipc	ra,0xffffc
    800056f0:	f12080e7          	jalr	-238(ra) # 800015fe <sleep>
  for(int i = 0; i < 3; i++){
    800056f4:	f9040613          	add	a2,s0,-112
    800056f8:	894e                	mv	s2,s3
    800056fa:	b765                	j	800056a2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056fc:	f9042503          	lw	a0,-112(s0)
    80005700:	00451693          	sll	a3,a0,0x4

  if(write)
    80005704:	00014797          	auipc	a5,0x14
    80005708:	2fc78793          	add	a5,a5,764 # 80019a00 <disk>
    8000570c:	00a50713          	add	a4,a0,10
    80005710:	0712                	sll	a4,a4,0x4
    80005712:	973e                	add	a4,a4,a5
    80005714:	01703633          	snez	a2,s7
    80005718:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000571a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000571e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005722:	6398                	ld	a4,0(a5)
    80005724:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005726:	0a868613          	add	a2,a3,168
    8000572a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000572c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000572e:	6390                	ld	a2,0(a5)
    80005730:	00d605b3          	add	a1,a2,a3
    80005734:	4741                	li	a4,16
    80005736:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005738:	4805                	li	a6,1
    8000573a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000573e:	f9442703          	lw	a4,-108(s0)
    80005742:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005746:	0712                	sll	a4,a4,0x4
    80005748:	963a                	add	a2,a2,a4
    8000574a:	058a0593          	add	a1,s4,88
    8000574e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005750:	0007b883          	ld	a7,0(a5)
    80005754:	9746                	add	a4,a4,a7
    80005756:	40000613          	li	a2,1024
    8000575a:	c710                	sw	a2,8(a4)
  if(write)
    8000575c:	001bb613          	seqz	a2,s7
    80005760:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005764:	00166613          	or	a2,a2,1
    80005768:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000576c:	f9842583          	lw	a1,-104(s0)
    80005770:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005774:	00250613          	add	a2,a0,2
    80005778:	0612                	sll	a2,a2,0x4
    8000577a:	963e                	add	a2,a2,a5
    8000577c:	577d                	li	a4,-1
    8000577e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005782:	0592                	sll	a1,a1,0x4
    80005784:	98ae                	add	a7,a7,a1
    80005786:	03068713          	add	a4,a3,48
    8000578a:	973e                	add	a4,a4,a5
    8000578c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005790:	6398                	ld	a4,0(a5)
    80005792:	972e                	add	a4,a4,a1
    80005794:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005798:	4689                	li	a3,2
    8000579a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000579e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057a2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800057a6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057aa:	6794                	ld	a3,8(a5)
    800057ac:	0026d703          	lhu	a4,2(a3)
    800057b0:	8b1d                	and	a4,a4,7
    800057b2:	0706                	sll	a4,a4,0x1
    800057b4:	96ba                	add	a3,a3,a4
    800057b6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057ba:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057be:	6798                	ld	a4,8(a5)
    800057c0:	00275783          	lhu	a5,2(a4)
    800057c4:	2785                	addw	a5,a5,1
    800057c6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057ca:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057ce:	100017b7          	lui	a5,0x10001
    800057d2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057d6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057da:	00014917          	auipc	s2,0x14
    800057de:	34e90913          	add	s2,s2,846 # 80019b28 <disk+0x128>
  while(b->disk == 1) {
    800057e2:	4485                	li	s1,1
    800057e4:	01079c63          	bne	a5,a6,800057fc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800057e8:	85ca                	mv	a1,s2
    800057ea:	8552                	mv	a0,s4
    800057ec:	ffffc097          	auipc	ra,0xffffc
    800057f0:	e12080e7          	jalr	-494(ra) # 800015fe <sleep>
  while(b->disk == 1) {
    800057f4:	004a2783          	lw	a5,4(s4)
    800057f8:	fe9788e3          	beq	a5,s1,800057e8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800057fc:	f9042903          	lw	s2,-112(s0)
    80005800:	00290713          	add	a4,s2,2
    80005804:	0712                	sll	a4,a4,0x4
    80005806:	00014797          	auipc	a5,0x14
    8000580a:	1fa78793          	add	a5,a5,506 # 80019a00 <disk>
    8000580e:	97ba                	add	a5,a5,a4
    80005810:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005814:	00014997          	auipc	s3,0x14
    80005818:	1ec98993          	add	s3,s3,492 # 80019a00 <disk>
    8000581c:	00491713          	sll	a4,s2,0x4
    80005820:	0009b783          	ld	a5,0(s3)
    80005824:	97ba                	add	a5,a5,a4
    80005826:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000582a:	854a                	mv	a0,s2
    8000582c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005830:	00000097          	auipc	ra,0x0
    80005834:	b5a080e7          	jalr	-1190(ra) # 8000538a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005838:	8885                	and	s1,s1,1
    8000583a:	f0ed                	bnez	s1,8000581c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000583c:	00014517          	auipc	a0,0x14
    80005840:	2ec50513          	add	a0,a0,748 # 80019b28 <disk+0x128>
    80005844:	00001097          	auipc	ra,0x1
    80005848:	c4c080e7          	jalr	-948(ra) # 80006490 <release>
}
    8000584c:	70a6                	ld	ra,104(sp)
    8000584e:	7406                	ld	s0,96(sp)
    80005850:	64e6                	ld	s1,88(sp)
    80005852:	6946                	ld	s2,80(sp)
    80005854:	69a6                	ld	s3,72(sp)
    80005856:	6a06                	ld	s4,64(sp)
    80005858:	7ae2                	ld	s5,56(sp)
    8000585a:	7b42                	ld	s6,48(sp)
    8000585c:	7ba2                	ld	s7,40(sp)
    8000585e:	7c02                	ld	s8,32(sp)
    80005860:	6ce2                	ld	s9,24(sp)
    80005862:	6165                	add	sp,sp,112
    80005864:	8082                	ret

0000000080005866 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005866:	1101                	add	sp,sp,-32
    80005868:	ec06                	sd	ra,24(sp)
    8000586a:	e822                	sd	s0,16(sp)
    8000586c:	e426                	sd	s1,8(sp)
    8000586e:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005870:	00014497          	auipc	s1,0x14
    80005874:	19048493          	add	s1,s1,400 # 80019a00 <disk>
    80005878:	00014517          	auipc	a0,0x14
    8000587c:	2b050513          	add	a0,a0,688 # 80019b28 <disk+0x128>
    80005880:	00001097          	auipc	ra,0x1
    80005884:	b5c080e7          	jalr	-1188(ra) # 800063dc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005888:	100017b7          	lui	a5,0x10001
    8000588c:	53b8                	lw	a4,96(a5)
    8000588e:	8b0d                	and	a4,a4,3
    80005890:	100017b7          	lui	a5,0x10001
    80005894:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005896:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000589a:	689c                	ld	a5,16(s1)
    8000589c:	0204d703          	lhu	a4,32(s1)
    800058a0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800058a4:	04f70863          	beq	a4,a5,800058f4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800058a8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058ac:	6898                	ld	a4,16(s1)
    800058ae:	0204d783          	lhu	a5,32(s1)
    800058b2:	8b9d                	and	a5,a5,7
    800058b4:	078e                	sll	a5,a5,0x3
    800058b6:	97ba                	add	a5,a5,a4
    800058b8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058ba:	00278713          	add	a4,a5,2
    800058be:	0712                	sll	a4,a4,0x4
    800058c0:	9726                	add	a4,a4,s1
    800058c2:	01074703          	lbu	a4,16(a4)
    800058c6:	e721                	bnez	a4,8000590e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058c8:	0789                	add	a5,a5,2
    800058ca:	0792                	sll	a5,a5,0x4
    800058cc:	97a6                	add	a5,a5,s1
    800058ce:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058d0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058d4:	ffffc097          	auipc	ra,0xffffc
    800058d8:	d8e080e7          	jalr	-626(ra) # 80001662 <wakeup>

    disk.used_idx += 1;
    800058dc:	0204d783          	lhu	a5,32(s1)
    800058e0:	2785                	addw	a5,a5,1
    800058e2:	17c2                	sll	a5,a5,0x30
    800058e4:	93c1                	srl	a5,a5,0x30
    800058e6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058ea:	6898                	ld	a4,16(s1)
    800058ec:	00275703          	lhu	a4,2(a4)
    800058f0:	faf71ce3          	bne	a4,a5,800058a8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800058f4:	00014517          	auipc	a0,0x14
    800058f8:	23450513          	add	a0,a0,564 # 80019b28 <disk+0x128>
    800058fc:	00001097          	auipc	ra,0x1
    80005900:	b94080e7          	jalr	-1132(ra) # 80006490 <release>
}
    80005904:	60e2                	ld	ra,24(sp)
    80005906:	6442                	ld	s0,16(sp)
    80005908:	64a2                	ld	s1,8(sp)
    8000590a:	6105                	add	sp,sp,32
    8000590c:	8082                	ret
      panic("virtio_disk_intr status");
    8000590e:	00003517          	auipc	a0,0x3
    80005912:	de250513          	add	a0,a0,-542 # 800086f0 <etext+0x6f0>
    80005916:	00000097          	auipc	ra,0x0
    8000591a:	54c080e7          	jalr	1356(ra) # 80005e62 <panic>

000000008000591e <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000591e:	1141                	add	sp,sp,-16
    80005920:	e422                	sd	s0,8(sp)
    80005922:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005924:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005928:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000592c:	0037979b          	sllw	a5,a5,0x3
    80005930:	02004737          	lui	a4,0x2004
    80005934:	97ba                	add	a5,a5,a4
    80005936:	0200c737          	lui	a4,0x200c
    8000593a:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000593c:	6318                	ld	a4,0(a4)
    8000593e:	000f4637          	lui	a2,0xf4
    80005942:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005946:	9732                	add	a4,a4,a2
    80005948:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000594a:	00259693          	sll	a3,a1,0x2
    8000594e:	96ae                	add	a3,a3,a1
    80005950:	068e                	sll	a3,a3,0x3
    80005952:	00014717          	auipc	a4,0x14
    80005956:	1ee70713          	add	a4,a4,494 # 80019b40 <timer_scratch>
    8000595a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000595c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000595e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005960:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005964:	00000797          	auipc	a5,0x0
    80005968:	95c78793          	add	a5,a5,-1700 # 800052c0 <timervec>
    8000596c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005970:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005974:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005978:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000597c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005980:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005984:	30479073          	csrw	mie,a5
}
    80005988:	6422                	ld	s0,8(sp)
    8000598a:	0141                	add	sp,sp,16
    8000598c:	8082                	ret

000000008000598e <start>:
{
    8000598e:	1141                	add	sp,sp,-16
    80005990:	e406                	sd	ra,8(sp)
    80005992:	e022                	sd	s0,0(sp)
    80005994:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005996:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000599a:	7779                	lui	a4,0xffffe
    8000599c:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca7f>
    800059a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059a2:	6705                	lui	a4,0x1
    800059a4:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059ae:	ffffb797          	auipc	a5,0xffffb
    800059b2:	9b478793          	add	a5,a5,-1612 # 80000362 <main>
    800059b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059ba:	4781                	li	a5,0
    800059bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059c0:	67c1                	lui	a5,0x10
    800059c2:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800059c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059d0:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059d8:	57fd                	li	a5,-1
    800059da:	83a9                	srl	a5,a5,0xa
    800059dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059e0:	47bd                	li	a5,15
    800059e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	f38080e7          	jalr	-200(ra) # 8000591e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059f2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800059f6:	30200073          	mret
}
    800059fa:	60a2                	ld	ra,8(sp)
    800059fc:	6402                	ld	s0,0(sp)
    800059fe:	0141                	add	sp,sp,16
    80005a00:	8082                	ret

0000000080005a02 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a02:	715d                	add	sp,sp,-80
    80005a04:	e486                	sd	ra,72(sp)
    80005a06:	e0a2                	sd	s0,64(sp)
    80005a08:	f84a                	sd	s2,48(sp)
    80005a0a:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a0c:	04c05663          	blez	a2,80005a58 <consolewrite+0x56>
    80005a10:	fc26                	sd	s1,56(sp)
    80005a12:	f44e                	sd	s3,40(sp)
    80005a14:	f052                	sd	s4,32(sp)
    80005a16:	ec56                	sd	s5,24(sp)
    80005a18:	8a2a                	mv	s4,a0
    80005a1a:	84ae                	mv	s1,a1
    80005a1c:	89b2                	mv	s3,a2
    80005a1e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a20:	5afd                	li	s5,-1
    80005a22:	4685                	li	a3,1
    80005a24:	8626                	mv	a2,s1
    80005a26:	85d2                	mv	a1,s4
    80005a28:	fbf40513          	add	a0,s0,-65
    80005a2c:	ffffc097          	auipc	ra,0xffffc
    80005a30:	030080e7          	jalr	48(ra) # 80001a5c <either_copyin>
    80005a34:	03550463          	beq	a0,s5,80005a5c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005a38:	fbf44503          	lbu	a0,-65(s0)
    80005a3c:	00000097          	auipc	ra,0x0
    80005a40:	7e4080e7          	jalr	2020(ra) # 80006220 <uartputc>
  for(i = 0; i < n; i++){
    80005a44:	2905                	addw	s2,s2,1
    80005a46:	0485                	add	s1,s1,1
    80005a48:	fd299de3          	bne	s3,s2,80005a22 <consolewrite+0x20>
    80005a4c:	894e                	mv	s2,s3
    80005a4e:	74e2                	ld	s1,56(sp)
    80005a50:	79a2                	ld	s3,40(sp)
    80005a52:	7a02                	ld	s4,32(sp)
    80005a54:	6ae2                	ld	s5,24(sp)
    80005a56:	a039                	j	80005a64 <consolewrite+0x62>
    80005a58:	4901                	li	s2,0
    80005a5a:	a029                	j	80005a64 <consolewrite+0x62>
    80005a5c:	74e2                	ld	s1,56(sp)
    80005a5e:	79a2                	ld	s3,40(sp)
    80005a60:	7a02                	ld	s4,32(sp)
    80005a62:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005a64:	854a                	mv	a0,s2
    80005a66:	60a6                	ld	ra,72(sp)
    80005a68:	6406                	ld	s0,64(sp)
    80005a6a:	7942                	ld	s2,48(sp)
    80005a6c:	6161                	add	sp,sp,80
    80005a6e:	8082                	ret

0000000080005a70 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a70:	711d                	add	sp,sp,-96
    80005a72:	ec86                	sd	ra,88(sp)
    80005a74:	e8a2                	sd	s0,80(sp)
    80005a76:	e4a6                	sd	s1,72(sp)
    80005a78:	e0ca                	sd	s2,64(sp)
    80005a7a:	fc4e                	sd	s3,56(sp)
    80005a7c:	f852                	sd	s4,48(sp)
    80005a7e:	f456                	sd	s5,40(sp)
    80005a80:	f05a                	sd	s6,32(sp)
    80005a82:	1080                	add	s0,sp,96
    80005a84:	8aaa                	mv	s5,a0
    80005a86:	8a2e                	mv	s4,a1
    80005a88:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a8a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a8e:	0001c517          	auipc	a0,0x1c
    80005a92:	1f250513          	add	a0,a0,498 # 80021c80 <cons>
    80005a96:	00001097          	auipc	ra,0x1
    80005a9a:	946080e7          	jalr	-1722(ra) # 800063dc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a9e:	0001c497          	auipc	s1,0x1c
    80005aa2:	1e248493          	add	s1,s1,482 # 80021c80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005aa6:	0001c917          	auipc	s2,0x1c
    80005aaa:	27290913          	add	s2,s2,626 # 80021d18 <cons+0x98>
  while(n > 0){
    80005aae:	0d305763          	blez	s3,80005b7c <consoleread+0x10c>
    while(cons.r == cons.w){
    80005ab2:	0984a783          	lw	a5,152(s1)
    80005ab6:	09c4a703          	lw	a4,156(s1)
    80005aba:	0af71c63          	bne	a4,a5,80005b72 <consoleread+0x102>
      if(killed(myproc())){
    80005abe:	ffffb097          	auipc	ra,0xffffb
    80005ac2:	492080e7          	jalr	1170(ra) # 80000f50 <myproc>
    80005ac6:	ffffc097          	auipc	ra,0xffffc
    80005aca:	de0080e7          	jalr	-544(ra) # 800018a6 <killed>
    80005ace:	e52d                	bnez	a0,80005b38 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005ad0:	85a6                	mv	a1,s1
    80005ad2:	854a                	mv	a0,s2
    80005ad4:	ffffc097          	auipc	ra,0xffffc
    80005ad8:	b2a080e7          	jalr	-1238(ra) # 800015fe <sleep>
    while(cons.r == cons.w){
    80005adc:	0984a783          	lw	a5,152(s1)
    80005ae0:	09c4a703          	lw	a4,156(s1)
    80005ae4:	fcf70de3          	beq	a4,a5,80005abe <consoleread+0x4e>
    80005ae8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005aea:	0001c717          	auipc	a4,0x1c
    80005aee:	19670713          	add	a4,a4,406 # 80021c80 <cons>
    80005af2:	0017869b          	addw	a3,a5,1
    80005af6:	08d72c23          	sw	a3,152(a4)
    80005afa:	07f7f693          	and	a3,a5,127
    80005afe:	9736                	add	a4,a4,a3
    80005b00:	01874703          	lbu	a4,24(a4)
    80005b04:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b08:	4691                	li	a3,4
    80005b0a:	04db8a63          	beq	s7,a3,80005b5e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b0e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b12:	4685                	li	a3,1
    80005b14:	faf40613          	add	a2,s0,-81
    80005b18:	85d2                	mv	a1,s4
    80005b1a:	8556                	mv	a0,s5
    80005b1c:	ffffc097          	auipc	ra,0xffffc
    80005b20:	eea080e7          	jalr	-278(ra) # 80001a06 <either_copyout>
    80005b24:	57fd                	li	a5,-1
    80005b26:	04f50a63          	beq	a0,a5,80005b7a <consoleread+0x10a>
      break;

    dst++;
    80005b2a:	0a05                	add	s4,s4,1
    --n;
    80005b2c:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80005b2e:	47a9                	li	a5,10
    80005b30:	06fb8163          	beq	s7,a5,80005b92 <consoleread+0x122>
    80005b34:	6be2                	ld	s7,24(sp)
    80005b36:	bfa5                	j	80005aae <consoleread+0x3e>
        release(&cons.lock);
    80005b38:	0001c517          	auipc	a0,0x1c
    80005b3c:	14850513          	add	a0,a0,328 # 80021c80 <cons>
    80005b40:	00001097          	auipc	ra,0x1
    80005b44:	950080e7          	jalr	-1712(ra) # 80006490 <release>
        return -1;
    80005b48:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005b4a:	60e6                	ld	ra,88(sp)
    80005b4c:	6446                	ld	s0,80(sp)
    80005b4e:	64a6                	ld	s1,72(sp)
    80005b50:	6906                	ld	s2,64(sp)
    80005b52:	79e2                	ld	s3,56(sp)
    80005b54:	7a42                	ld	s4,48(sp)
    80005b56:	7aa2                	ld	s5,40(sp)
    80005b58:	7b02                	ld	s6,32(sp)
    80005b5a:	6125                	add	sp,sp,96
    80005b5c:	8082                	ret
      if(n < target){
    80005b5e:	0009871b          	sext.w	a4,s3
    80005b62:	01677a63          	bgeu	a4,s6,80005b76 <consoleread+0x106>
        cons.r--;
    80005b66:	0001c717          	auipc	a4,0x1c
    80005b6a:	1af72923          	sw	a5,434(a4) # 80021d18 <cons+0x98>
    80005b6e:	6be2                	ld	s7,24(sp)
    80005b70:	a031                	j	80005b7c <consoleread+0x10c>
    80005b72:	ec5e                	sd	s7,24(sp)
    80005b74:	bf9d                	j	80005aea <consoleread+0x7a>
    80005b76:	6be2                	ld	s7,24(sp)
    80005b78:	a011                	j	80005b7c <consoleread+0x10c>
    80005b7a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005b7c:	0001c517          	auipc	a0,0x1c
    80005b80:	10450513          	add	a0,a0,260 # 80021c80 <cons>
    80005b84:	00001097          	auipc	ra,0x1
    80005b88:	90c080e7          	jalr	-1780(ra) # 80006490 <release>
  return target - n;
    80005b8c:	413b053b          	subw	a0,s6,s3
    80005b90:	bf6d                	j	80005b4a <consoleread+0xda>
    80005b92:	6be2                	ld	s7,24(sp)
    80005b94:	b7e5                	j	80005b7c <consoleread+0x10c>

0000000080005b96 <consputc>:
{
    80005b96:	1141                	add	sp,sp,-16
    80005b98:	e406                	sd	ra,8(sp)
    80005b9a:	e022                	sd	s0,0(sp)
    80005b9c:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80005b9e:	10000793          	li	a5,256
    80005ba2:	00f50a63          	beq	a0,a5,80005bb6 <consputc+0x20>
    uartputc_sync(c);
    80005ba6:	00000097          	auipc	ra,0x0
    80005baa:	59c080e7          	jalr	1436(ra) # 80006142 <uartputc_sync>
}
    80005bae:	60a2                	ld	ra,8(sp)
    80005bb0:	6402                	ld	s0,0(sp)
    80005bb2:	0141                	add	sp,sp,16
    80005bb4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bb6:	4521                	li	a0,8
    80005bb8:	00000097          	auipc	ra,0x0
    80005bbc:	58a080e7          	jalr	1418(ra) # 80006142 <uartputc_sync>
    80005bc0:	02000513          	li	a0,32
    80005bc4:	00000097          	auipc	ra,0x0
    80005bc8:	57e080e7          	jalr	1406(ra) # 80006142 <uartputc_sync>
    80005bcc:	4521                	li	a0,8
    80005bce:	00000097          	auipc	ra,0x0
    80005bd2:	574080e7          	jalr	1396(ra) # 80006142 <uartputc_sync>
    80005bd6:	bfe1                	j	80005bae <consputc+0x18>

0000000080005bd8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bd8:	1101                	add	sp,sp,-32
    80005bda:	ec06                	sd	ra,24(sp)
    80005bdc:	e822                	sd	s0,16(sp)
    80005bde:	e426                	sd	s1,8(sp)
    80005be0:	1000                	add	s0,sp,32
    80005be2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005be4:	0001c517          	auipc	a0,0x1c
    80005be8:	09c50513          	add	a0,a0,156 # 80021c80 <cons>
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	7f0080e7          	jalr	2032(ra) # 800063dc <acquire>

  switch(c){
    80005bf4:	47d5                	li	a5,21
    80005bf6:	0af48563          	beq	s1,a5,80005ca0 <consoleintr+0xc8>
    80005bfa:	0297c963          	blt	a5,s1,80005c2c <consoleintr+0x54>
    80005bfe:	47a1                	li	a5,8
    80005c00:	0ef48c63          	beq	s1,a5,80005cf8 <consoleintr+0x120>
    80005c04:	47c1                	li	a5,16
    80005c06:	10f49f63          	bne	s1,a5,80005d24 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005c0a:	ffffc097          	auipc	ra,0xffffc
    80005c0e:	ea8080e7          	jalr	-344(ra) # 80001ab2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c12:	0001c517          	auipc	a0,0x1c
    80005c16:	06e50513          	add	a0,a0,110 # 80021c80 <cons>
    80005c1a:	00001097          	auipc	ra,0x1
    80005c1e:	876080e7          	jalr	-1930(ra) # 80006490 <release>
}
    80005c22:	60e2                	ld	ra,24(sp)
    80005c24:	6442                	ld	s0,16(sp)
    80005c26:	64a2                	ld	s1,8(sp)
    80005c28:	6105                	add	sp,sp,32
    80005c2a:	8082                	ret
  switch(c){
    80005c2c:	07f00793          	li	a5,127
    80005c30:	0cf48463          	beq	s1,a5,80005cf8 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c34:	0001c717          	auipc	a4,0x1c
    80005c38:	04c70713          	add	a4,a4,76 # 80021c80 <cons>
    80005c3c:	0a072783          	lw	a5,160(a4)
    80005c40:	09872703          	lw	a4,152(a4)
    80005c44:	9f99                	subw	a5,a5,a4
    80005c46:	07f00713          	li	a4,127
    80005c4a:	fcf764e3          	bltu	a4,a5,80005c12 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005c4e:	47b5                	li	a5,13
    80005c50:	0cf48d63          	beq	s1,a5,80005d2a <consoleintr+0x152>
      consputc(c);
    80005c54:	8526                	mv	a0,s1
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	f40080e7          	jalr	-192(ra) # 80005b96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c5e:	0001c797          	auipc	a5,0x1c
    80005c62:	02278793          	add	a5,a5,34 # 80021c80 <cons>
    80005c66:	0a07a683          	lw	a3,160(a5)
    80005c6a:	0016871b          	addw	a4,a3,1
    80005c6e:	0007061b          	sext.w	a2,a4
    80005c72:	0ae7a023          	sw	a4,160(a5)
    80005c76:	07f6f693          	and	a3,a3,127
    80005c7a:	97b6                	add	a5,a5,a3
    80005c7c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c80:	47a9                	li	a5,10
    80005c82:	0cf48b63          	beq	s1,a5,80005d58 <consoleintr+0x180>
    80005c86:	4791                	li	a5,4
    80005c88:	0cf48863          	beq	s1,a5,80005d58 <consoleintr+0x180>
    80005c8c:	0001c797          	auipc	a5,0x1c
    80005c90:	08c7a783          	lw	a5,140(a5) # 80021d18 <cons+0x98>
    80005c94:	9f1d                	subw	a4,a4,a5
    80005c96:	08000793          	li	a5,128
    80005c9a:	f6f71ce3          	bne	a4,a5,80005c12 <consoleintr+0x3a>
    80005c9e:	a86d                	j	80005d58 <consoleintr+0x180>
    80005ca0:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005ca2:	0001c717          	auipc	a4,0x1c
    80005ca6:	fde70713          	add	a4,a4,-34 # 80021c80 <cons>
    80005caa:	0a072783          	lw	a5,160(a4)
    80005cae:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cb2:	0001c497          	auipc	s1,0x1c
    80005cb6:	fce48493          	add	s1,s1,-50 # 80021c80 <cons>
    while(cons.e != cons.w &&
    80005cba:	4929                	li	s2,10
    80005cbc:	02f70a63          	beq	a4,a5,80005cf0 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cc0:	37fd                	addw	a5,a5,-1
    80005cc2:	07f7f713          	and	a4,a5,127
    80005cc6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cc8:	01874703          	lbu	a4,24(a4)
    80005ccc:	03270463          	beq	a4,s2,80005cf4 <consoleintr+0x11c>
      cons.e--;
    80005cd0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cd4:	10000513          	li	a0,256
    80005cd8:	00000097          	auipc	ra,0x0
    80005cdc:	ebe080e7          	jalr	-322(ra) # 80005b96 <consputc>
    while(cons.e != cons.w &&
    80005ce0:	0a04a783          	lw	a5,160(s1)
    80005ce4:	09c4a703          	lw	a4,156(s1)
    80005ce8:	fcf71ce3          	bne	a4,a5,80005cc0 <consoleintr+0xe8>
    80005cec:	6902                	ld	s2,0(sp)
    80005cee:	b715                	j	80005c12 <consoleintr+0x3a>
    80005cf0:	6902                	ld	s2,0(sp)
    80005cf2:	b705                	j	80005c12 <consoleintr+0x3a>
    80005cf4:	6902                	ld	s2,0(sp)
    80005cf6:	bf31                	j	80005c12 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005cf8:	0001c717          	auipc	a4,0x1c
    80005cfc:	f8870713          	add	a4,a4,-120 # 80021c80 <cons>
    80005d00:	0a072783          	lw	a5,160(a4)
    80005d04:	09c72703          	lw	a4,156(a4)
    80005d08:	f0f705e3          	beq	a4,a5,80005c12 <consoleintr+0x3a>
      cons.e--;
    80005d0c:	37fd                	addw	a5,a5,-1
    80005d0e:	0001c717          	auipc	a4,0x1c
    80005d12:	00f72923          	sw	a5,18(a4) # 80021d20 <cons+0xa0>
      consputc(BACKSPACE);
    80005d16:	10000513          	li	a0,256
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	e7c080e7          	jalr	-388(ra) # 80005b96 <consputc>
    80005d22:	bdc5                	j	80005c12 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d24:	ee0487e3          	beqz	s1,80005c12 <consoleintr+0x3a>
    80005d28:	b731                	j	80005c34 <consoleintr+0x5c>
      consputc(c);
    80005d2a:	4529                	li	a0,10
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	e6a080e7          	jalr	-406(ra) # 80005b96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d34:	0001c797          	auipc	a5,0x1c
    80005d38:	f4c78793          	add	a5,a5,-180 # 80021c80 <cons>
    80005d3c:	0a07a703          	lw	a4,160(a5)
    80005d40:	0017069b          	addw	a3,a4,1
    80005d44:	0006861b          	sext.w	a2,a3
    80005d48:	0ad7a023          	sw	a3,160(a5)
    80005d4c:	07f77713          	and	a4,a4,127
    80005d50:	97ba                	add	a5,a5,a4
    80005d52:	4729                	li	a4,10
    80005d54:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d58:	0001c797          	auipc	a5,0x1c
    80005d5c:	fcc7a223          	sw	a2,-60(a5) # 80021d1c <cons+0x9c>
        wakeup(&cons.r);
    80005d60:	0001c517          	auipc	a0,0x1c
    80005d64:	fb850513          	add	a0,a0,-72 # 80021d18 <cons+0x98>
    80005d68:	ffffc097          	auipc	ra,0xffffc
    80005d6c:	8fa080e7          	jalr	-1798(ra) # 80001662 <wakeup>
    80005d70:	b54d                	j	80005c12 <consoleintr+0x3a>

0000000080005d72 <consoleinit>:

void
consoleinit(void)
{
    80005d72:	1141                	add	sp,sp,-16
    80005d74:	e406                	sd	ra,8(sp)
    80005d76:	e022                	sd	s0,0(sp)
    80005d78:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d7a:	00003597          	auipc	a1,0x3
    80005d7e:	98e58593          	add	a1,a1,-1650 # 80008708 <etext+0x708>
    80005d82:	0001c517          	auipc	a0,0x1c
    80005d86:	efe50513          	add	a0,a0,-258 # 80021c80 <cons>
    80005d8a:	00000097          	auipc	ra,0x0
    80005d8e:	5c2080e7          	jalr	1474(ra) # 8000634c <initlock>

  uartinit();
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	354080e7          	jalr	852(ra) # 800060e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d9a:	00013797          	auipc	a5,0x13
    80005d9e:	c0e78793          	add	a5,a5,-1010 # 800189a8 <devsw>
    80005da2:	00000717          	auipc	a4,0x0
    80005da6:	cce70713          	add	a4,a4,-818 # 80005a70 <consoleread>
    80005daa:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dac:	00000717          	auipc	a4,0x0
    80005db0:	c5670713          	add	a4,a4,-938 # 80005a02 <consolewrite>
    80005db4:	ef98                	sd	a4,24(a5)
}
    80005db6:	60a2                	ld	ra,8(sp)
    80005db8:	6402                	ld	s0,0(sp)
    80005dba:	0141                	add	sp,sp,16
    80005dbc:	8082                	ret

0000000080005dbe <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005dbe:	7179                	add	sp,sp,-48
    80005dc0:	f406                	sd	ra,40(sp)
    80005dc2:	f022                	sd	s0,32(sp)
    80005dc4:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dc6:	c219                	beqz	a2,80005dcc <printint+0xe>
    80005dc8:	08054963          	bltz	a0,80005e5a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005dcc:	2501                	sext.w	a0,a0
    80005dce:	4881                	li	a7,0
    80005dd0:	fd040693          	add	a3,s0,-48

  i = 0;
    80005dd4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dd6:	2581                	sext.w	a1,a1
    80005dd8:	00003617          	auipc	a2,0x3
    80005ddc:	aa060613          	add	a2,a2,-1376 # 80008878 <digits>
    80005de0:	883a                	mv	a6,a4
    80005de2:	2705                	addw	a4,a4,1
    80005de4:	02b577bb          	remuw	a5,a0,a1
    80005de8:	1782                	sll	a5,a5,0x20
    80005dea:	9381                	srl	a5,a5,0x20
    80005dec:	97b2                	add	a5,a5,a2
    80005dee:	0007c783          	lbu	a5,0(a5)
    80005df2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005df6:	0005079b          	sext.w	a5,a0
    80005dfa:	02b5553b          	divuw	a0,a0,a1
    80005dfe:	0685                	add	a3,a3,1
    80005e00:	feb7f0e3          	bgeu	a5,a1,80005de0 <printint+0x22>

  if(sign)
    80005e04:	00088c63          	beqz	a7,80005e1c <printint+0x5e>
    buf[i++] = '-';
    80005e08:	fe070793          	add	a5,a4,-32
    80005e0c:	00878733          	add	a4,a5,s0
    80005e10:	02d00793          	li	a5,45
    80005e14:	fef70823          	sb	a5,-16(a4)
    80005e18:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80005e1c:	02e05b63          	blez	a4,80005e52 <printint+0x94>
    80005e20:	ec26                	sd	s1,24(sp)
    80005e22:	e84a                	sd	s2,16(sp)
    80005e24:	fd040793          	add	a5,s0,-48
    80005e28:	00e784b3          	add	s1,a5,a4
    80005e2c:	fff78913          	add	s2,a5,-1
    80005e30:	993a                	add	s2,s2,a4
    80005e32:	377d                	addw	a4,a4,-1
    80005e34:	1702                	sll	a4,a4,0x20
    80005e36:	9301                	srl	a4,a4,0x20
    80005e38:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e3c:	fff4c503          	lbu	a0,-1(s1)
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	d56080e7          	jalr	-682(ra) # 80005b96 <consputc>
  while(--i >= 0)
    80005e48:	14fd                	add	s1,s1,-1
    80005e4a:	ff2499e3          	bne	s1,s2,80005e3c <printint+0x7e>
    80005e4e:	64e2                	ld	s1,24(sp)
    80005e50:	6942                	ld	s2,16(sp)
}
    80005e52:	70a2                	ld	ra,40(sp)
    80005e54:	7402                	ld	s0,32(sp)
    80005e56:	6145                	add	sp,sp,48
    80005e58:	8082                	ret
    x = -xx;
    80005e5a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e5e:	4885                	li	a7,1
    x = -xx;
    80005e60:	bf85                	j	80005dd0 <printint+0x12>

0000000080005e62 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e62:	1101                	add	sp,sp,-32
    80005e64:	ec06                	sd	ra,24(sp)
    80005e66:	e822                	sd	s0,16(sp)
    80005e68:	e426                	sd	s1,8(sp)
    80005e6a:	1000                	add	s0,sp,32
    80005e6c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e6e:	0001c797          	auipc	a5,0x1c
    80005e72:	ec07a923          	sw	zero,-302(a5) # 80021d40 <pr+0x18>
  printf("panic: ");
    80005e76:	00003517          	auipc	a0,0x3
    80005e7a:	89a50513          	add	a0,a0,-1894 # 80008710 <etext+0x710>
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	02e080e7          	jalr	46(ra) # 80005eac <printf>
  printf(s);
    80005e86:	8526                	mv	a0,s1
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	024080e7          	jalr	36(ra) # 80005eac <printf>
  printf("\n");
    80005e90:	00002517          	auipc	a0,0x2
    80005e94:	18850513          	add	a0,a0,392 # 80008018 <etext+0x18>
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	014080e7          	jalr	20(ra) # 80005eac <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ea0:	4785                	li	a5,1
    80005ea2:	00003717          	auipc	a4,0x3
    80005ea6:	a4f72d23          	sw	a5,-1446(a4) # 800088fc <panicked>
  for(;;)
    80005eaa:	a001                	j	80005eaa <panic+0x48>

0000000080005eac <printf>:
{
    80005eac:	7131                	add	sp,sp,-192
    80005eae:	fc86                	sd	ra,120(sp)
    80005eb0:	f8a2                	sd	s0,112(sp)
    80005eb2:	e8d2                	sd	s4,80(sp)
    80005eb4:	f06a                	sd	s10,32(sp)
    80005eb6:	0100                	add	s0,sp,128
    80005eb8:	8a2a                	mv	s4,a0
    80005eba:	e40c                	sd	a1,8(s0)
    80005ebc:	e810                	sd	a2,16(s0)
    80005ebe:	ec14                	sd	a3,24(s0)
    80005ec0:	f018                	sd	a4,32(s0)
    80005ec2:	f41c                	sd	a5,40(s0)
    80005ec4:	03043823          	sd	a6,48(s0)
    80005ec8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ecc:	0001cd17          	auipc	s10,0x1c
    80005ed0:	e74d2d03          	lw	s10,-396(s10) # 80021d40 <pr+0x18>
  if(locking)
    80005ed4:	040d1463          	bnez	s10,80005f1c <printf+0x70>
  if (fmt == 0)
    80005ed8:	040a0b63          	beqz	s4,80005f2e <printf+0x82>
  va_start(ap, fmt);
    80005edc:	00840793          	add	a5,s0,8
    80005ee0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ee4:	000a4503          	lbu	a0,0(s4)
    80005ee8:	18050b63          	beqz	a0,8000607e <printf+0x1d2>
    80005eec:	f4a6                	sd	s1,104(sp)
    80005eee:	f0ca                	sd	s2,96(sp)
    80005ef0:	ecce                	sd	s3,88(sp)
    80005ef2:	e4d6                	sd	s5,72(sp)
    80005ef4:	e0da                	sd	s6,64(sp)
    80005ef6:	fc5e                	sd	s7,56(sp)
    80005ef8:	f862                	sd	s8,48(sp)
    80005efa:	f466                	sd	s9,40(sp)
    80005efc:	ec6e                	sd	s11,24(sp)
    80005efe:	4981                	li	s3,0
    if(c != '%'){
    80005f00:	02500b13          	li	s6,37
    switch(c){
    80005f04:	07000b93          	li	s7,112
  consputc('x');
    80005f08:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f0a:	00003a97          	auipc	s5,0x3
    80005f0e:	96ea8a93          	add	s5,s5,-1682 # 80008878 <digits>
    switch(c){
    80005f12:	07300c13          	li	s8,115
    80005f16:	06400d93          	li	s11,100
    80005f1a:	a0b1                	j	80005f66 <printf+0xba>
    acquire(&pr.lock);
    80005f1c:	0001c517          	auipc	a0,0x1c
    80005f20:	e0c50513          	add	a0,a0,-500 # 80021d28 <pr>
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	4b8080e7          	jalr	1208(ra) # 800063dc <acquire>
    80005f2c:	b775                	j	80005ed8 <printf+0x2c>
    80005f2e:	f4a6                	sd	s1,104(sp)
    80005f30:	f0ca                	sd	s2,96(sp)
    80005f32:	ecce                	sd	s3,88(sp)
    80005f34:	e4d6                	sd	s5,72(sp)
    80005f36:	e0da                	sd	s6,64(sp)
    80005f38:	fc5e                	sd	s7,56(sp)
    80005f3a:	f862                	sd	s8,48(sp)
    80005f3c:	f466                	sd	s9,40(sp)
    80005f3e:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005f40:	00002517          	auipc	a0,0x2
    80005f44:	7e050513          	add	a0,a0,2016 # 80008720 <etext+0x720>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	f1a080e7          	jalr	-230(ra) # 80005e62 <panic>
      consputc(c);
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	c46080e7          	jalr	-954(ra) # 80005b96 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f58:	2985                	addw	s3,s3,1
    80005f5a:	013a07b3          	add	a5,s4,s3
    80005f5e:	0007c503          	lbu	a0,0(a5)
    80005f62:	10050563          	beqz	a0,8000606c <printf+0x1c0>
    if(c != '%'){
    80005f66:	ff6515e3          	bne	a0,s6,80005f50 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005f6a:	2985                	addw	s3,s3,1
    80005f6c:	013a07b3          	add	a5,s4,s3
    80005f70:	0007c783          	lbu	a5,0(a5)
    80005f74:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f78:	10078b63          	beqz	a5,8000608e <printf+0x1e2>
    switch(c){
    80005f7c:	05778a63          	beq	a5,s7,80005fd0 <printf+0x124>
    80005f80:	02fbf663          	bgeu	s7,a5,80005fac <printf+0x100>
    80005f84:	09878863          	beq	a5,s8,80006014 <printf+0x168>
    80005f88:	07800713          	li	a4,120
    80005f8c:	0ce79563          	bne	a5,a4,80006056 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005f90:	f8843783          	ld	a5,-120(s0)
    80005f94:	00878713          	add	a4,a5,8
    80005f98:	f8e43423          	sd	a4,-120(s0)
    80005f9c:	4605                	li	a2,1
    80005f9e:	85e6                	mv	a1,s9
    80005fa0:	4388                	lw	a0,0(a5)
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	e1c080e7          	jalr	-484(ra) # 80005dbe <printint>
      break;
    80005faa:	b77d                	j	80005f58 <printf+0xac>
    switch(c){
    80005fac:	09678f63          	beq	a5,s6,8000604a <printf+0x19e>
    80005fb0:	0bb79363          	bne	a5,s11,80006056 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005fb4:	f8843783          	ld	a5,-120(s0)
    80005fb8:	00878713          	add	a4,a5,8
    80005fbc:	f8e43423          	sd	a4,-120(s0)
    80005fc0:	4605                	li	a2,1
    80005fc2:	45a9                	li	a1,10
    80005fc4:	4388                	lw	a0,0(a5)
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	df8080e7          	jalr	-520(ra) # 80005dbe <printint>
      break;
    80005fce:	b769                	j	80005f58 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005fd0:	f8843783          	ld	a5,-120(s0)
    80005fd4:	00878713          	add	a4,a5,8
    80005fd8:	f8e43423          	sd	a4,-120(s0)
    80005fdc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005fe0:	03000513          	li	a0,48
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	bb2080e7          	jalr	-1102(ra) # 80005b96 <consputc>
  consputc('x');
    80005fec:	07800513          	li	a0,120
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	ba6080e7          	jalr	-1114(ra) # 80005b96 <consputc>
    80005ff8:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ffa:	03c95793          	srl	a5,s2,0x3c
    80005ffe:	97d6                	add	a5,a5,s5
    80006000:	0007c503          	lbu	a0,0(a5)
    80006004:	00000097          	auipc	ra,0x0
    80006008:	b92080e7          	jalr	-1134(ra) # 80005b96 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000600c:	0912                	sll	s2,s2,0x4
    8000600e:	34fd                	addw	s1,s1,-1
    80006010:	f4ed                	bnez	s1,80005ffa <printf+0x14e>
    80006012:	b799                	j	80005f58 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80006014:	f8843783          	ld	a5,-120(s0)
    80006018:	00878713          	add	a4,a5,8
    8000601c:	f8e43423          	sd	a4,-120(s0)
    80006020:	6384                	ld	s1,0(a5)
    80006022:	cc89                	beqz	s1,8000603c <printf+0x190>
      for(; *s; s++)
    80006024:	0004c503          	lbu	a0,0(s1)
    80006028:	d905                	beqz	a0,80005f58 <printf+0xac>
        consputc(*s);
    8000602a:	00000097          	auipc	ra,0x0
    8000602e:	b6c080e7          	jalr	-1172(ra) # 80005b96 <consputc>
      for(; *s; s++)
    80006032:	0485                	add	s1,s1,1
    80006034:	0004c503          	lbu	a0,0(s1)
    80006038:	f96d                	bnez	a0,8000602a <printf+0x17e>
    8000603a:	bf39                	j	80005f58 <printf+0xac>
        s = "(null)";
    8000603c:	00002497          	auipc	s1,0x2
    80006040:	6dc48493          	add	s1,s1,1756 # 80008718 <etext+0x718>
      for(; *s; s++)
    80006044:	02800513          	li	a0,40
    80006048:	b7cd                	j	8000602a <printf+0x17e>
      consputc('%');
    8000604a:	855a                	mv	a0,s6
    8000604c:	00000097          	auipc	ra,0x0
    80006050:	b4a080e7          	jalr	-1206(ra) # 80005b96 <consputc>
      break;
    80006054:	b711                	j	80005f58 <printf+0xac>
      consputc('%');
    80006056:	855a                	mv	a0,s6
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	b3e080e7          	jalr	-1218(ra) # 80005b96 <consputc>
      consputc(c);
    80006060:	8526                	mv	a0,s1
    80006062:	00000097          	auipc	ra,0x0
    80006066:	b34080e7          	jalr	-1228(ra) # 80005b96 <consputc>
      break;
    8000606a:	b5fd                	j	80005f58 <printf+0xac>
    8000606c:	74a6                	ld	s1,104(sp)
    8000606e:	7906                	ld	s2,96(sp)
    80006070:	69e6                	ld	s3,88(sp)
    80006072:	6aa6                	ld	s5,72(sp)
    80006074:	6b06                	ld	s6,64(sp)
    80006076:	7be2                	ld	s7,56(sp)
    80006078:	7c42                	ld	s8,48(sp)
    8000607a:	7ca2                	ld	s9,40(sp)
    8000607c:	6de2                	ld	s11,24(sp)
  if(locking)
    8000607e:	020d1263          	bnez	s10,800060a2 <printf+0x1f6>
}
    80006082:	70e6                	ld	ra,120(sp)
    80006084:	7446                	ld	s0,112(sp)
    80006086:	6a46                	ld	s4,80(sp)
    80006088:	7d02                	ld	s10,32(sp)
    8000608a:	6129                	add	sp,sp,192
    8000608c:	8082                	ret
    8000608e:	74a6                	ld	s1,104(sp)
    80006090:	7906                	ld	s2,96(sp)
    80006092:	69e6                	ld	s3,88(sp)
    80006094:	6aa6                	ld	s5,72(sp)
    80006096:	6b06                	ld	s6,64(sp)
    80006098:	7be2                	ld	s7,56(sp)
    8000609a:	7c42                	ld	s8,48(sp)
    8000609c:	7ca2                	ld	s9,40(sp)
    8000609e:	6de2                	ld	s11,24(sp)
    800060a0:	bff9                	j	8000607e <printf+0x1d2>
    release(&pr.lock);
    800060a2:	0001c517          	auipc	a0,0x1c
    800060a6:	c8650513          	add	a0,a0,-890 # 80021d28 <pr>
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	3e6080e7          	jalr	998(ra) # 80006490 <release>
}
    800060b2:	bfc1                	j	80006082 <printf+0x1d6>

00000000800060b4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060b4:	1101                	add	sp,sp,-32
    800060b6:	ec06                	sd	ra,24(sp)
    800060b8:	e822                	sd	s0,16(sp)
    800060ba:	e426                	sd	s1,8(sp)
    800060bc:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    800060be:	0001c497          	auipc	s1,0x1c
    800060c2:	c6a48493          	add	s1,s1,-918 # 80021d28 <pr>
    800060c6:	00002597          	auipc	a1,0x2
    800060ca:	66a58593          	add	a1,a1,1642 # 80008730 <etext+0x730>
    800060ce:	8526                	mv	a0,s1
    800060d0:	00000097          	auipc	ra,0x0
    800060d4:	27c080e7          	jalr	636(ra) # 8000634c <initlock>
  pr.locking = 1;
    800060d8:	4785                	li	a5,1
    800060da:	cc9c                	sw	a5,24(s1)
}
    800060dc:	60e2                	ld	ra,24(sp)
    800060de:	6442                	ld	s0,16(sp)
    800060e0:	64a2                	ld	s1,8(sp)
    800060e2:	6105                	add	sp,sp,32
    800060e4:	8082                	ret

00000000800060e6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060e6:	1141                	add	sp,sp,-16
    800060e8:	e406                	sd	ra,8(sp)
    800060ea:	e022                	sd	s0,0(sp)
    800060ec:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060ee:	100007b7          	lui	a5,0x10000
    800060f2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060f6:	10000737          	lui	a4,0x10000
    800060fa:	f8000693          	li	a3,-128
    800060fe:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006102:	468d                	li	a3,3
    80006104:	10000637          	lui	a2,0x10000
    80006108:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000610c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006110:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006114:	10000737          	lui	a4,0x10000
    80006118:	461d                	li	a2,7
    8000611a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000611e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006122:	00002597          	auipc	a1,0x2
    80006126:	61658593          	add	a1,a1,1558 # 80008738 <etext+0x738>
    8000612a:	0001c517          	auipc	a0,0x1c
    8000612e:	c1e50513          	add	a0,a0,-994 # 80021d48 <uart_tx_lock>
    80006132:	00000097          	auipc	ra,0x0
    80006136:	21a080e7          	jalr	538(ra) # 8000634c <initlock>
}
    8000613a:	60a2                	ld	ra,8(sp)
    8000613c:	6402                	ld	s0,0(sp)
    8000613e:	0141                	add	sp,sp,16
    80006140:	8082                	ret

0000000080006142 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006142:	1101                	add	sp,sp,-32
    80006144:	ec06                	sd	ra,24(sp)
    80006146:	e822                	sd	s0,16(sp)
    80006148:	e426                	sd	s1,8(sp)
    8000614a:	1000                	add	s0,sp,32
    8000614c:	84aa                	mv	s1,a0
  push_off();
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	242080e7          	jalr	578(ra) # 80006390 <push_off>

  if(panicked){
    80006156:	00002797          	auipc	a5,0x2
    8000615a:	7a67a783          	lw	a5,1958(a5) # 800088fc <panicked>
    8000615e:	eb85                	bnez	a5,8000618e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006160:	10000737          	lui	a4,0x10000
    80006164:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006166:	00074783          	lbu	a5,0(a4)
    8000616a:	0207f793          	and	a5,a5,32
    8000616e:	dfe5                	beqz	a5,80006166 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006170:	0ff4f513          	zext.b	a0,s1
    80006174:	100007b7          	lui	a5,0x10000
    80006178:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	2b4080e7          	jalr	692(ra) # 80006430 <pop_off>
}
    80006184:	60e2                	ld	ra,24(sp)
    80006186:	6442                	ld	s0,16(sp)
    80006188:	64a2                	ld	s1,8(sp)
    8000618a:	6105                	add	sp,sp,32
    8000618c:	8082                	ret
    for(;;)
    8000618e:	a001                	j	8000618e <uartputc_sync+0x4c>

0000000080006190 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006190:	00002797          	auipc	a5,0x2
    80006194:	7707b783          	ld	a5,1904(a5) # 80008900 <uart_tx_r>
    80006198:	00002717          	auipc	a4,0x2
    8000619c:	77073703          	ld	a4,1904(a4) # 80008908 <uart_tx_w>
    800061a0:	06f70f63          	beq	a4,a5,8000621e <uartstart+0x8e>
{
    800061a4:	7139                	add	sp,sp,-64
    800061a6:	fc06                	sd	ra,56(sp)
    800061a8:	f822                	sd	s0,48(sp)
    800061aa:	f426                	sd	s1,40(sp)
    800061ac:	f04a                	sd	s2,32(sp)
    800061ae:	ec4e                	sd	s3,24(sp)
    800061b0:	e852                	sd	s4,16(sp)
    800061b2:	e456                	sd	s5,8(sp)
    800061b4:	e05a                	sd	s6,0(sp)
    800061b6:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061b8:	10000937          	lui	s2,0x10000
    800061bc:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061be:	0001ca97          	auipc	s5,0x1c
    800061c2:	b8aa8a93          	add	s5,s5,-1142 # 80021d48 <uart_tx_lock>
    uart_tx_r += 1;
    800061c6:	00002497          	auipc	s1,0x2
    800061ca:	73a48493          	add	s1,s1,1850 # 80008900 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800061ce:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800061d2:	00002997          	auipc	s3,0x2
    800061d6:	73698993          	add	s3,s3,1846 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061da:	00094703          	lbu	a4,0(s2)
    800061de:	02077713          	and	a4,a4,32
    800061e2:	c705                	beqz	a4,8000620a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061e4:	01f7f713          	and	a4,a5,31
    800061e8:	9756                	add	a4,a4,s5
    800061ea:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800061ee:	0785                	add	a5,a5,1
    800061f0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800061f2:	8526                	mv	a0,s1
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	46e080e7          	jalr	1134(ra) # 80001662 <wakeup>
    WriteReg(THR, c);
    800061fc:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006200:	609c                	ld	a5,0(s1)
    80006202:	0009b703          	ld	a4,0(s3)
    80006206:	fcf71ae3          	bne	a4,a5,800061da <uartstart+0x4a>
  }
}
    8000620a:	70e2                	ld	ra,56(sp)
    8000620c:	7442                	ld	s0,48(sp)
    8000620e:	74a2                	ld	s1,40(sp)
    80006210:	7902                	ld	s2,32(sp)
    80006212:	69e2                	ld	s3,24(sp)
    80006214:	6a42                	ld	s4,16(sp)
    80006216:	6aa2                	ld	s5,8(sp)
    80006218:	6b02                	ld	s6,0(sp)
    8000621a:	6121                	add	sp,sp,64
    8000621c:	8082                	ret
    8000621e:	8082                	ret

0000000080006220 <uartputc>:
{
    80006220:	7179                	add	sp,sp,-48
    80006222:	f406                	sd	ra,40(sp)
    80006224:	f022                	sd	s0,32(sp)
    80006226:	ec26                	sd	s1,24(sp)
    80006228:	e84a                	sd	s2,16(sp)
    8000622a:	e44e                	sd	s3,8(sp)
    8000622c:	e052                	sd	s4,0(sp)
    8000622e:	1800                	add	s0,sp,48
    80006230:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006232:	0001c517          	auipc	a0,0x1c
    80006236:	b1650513          	add	a0,a0,-1258 # 80021d48 <uart_tx_lock>
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	1a2080e7          	jalr	418(ra) # 800063dc <acquire>
  if(panicked){
    80006242:	00002797          	auipc	a5,0x2
    80006246:	6ba7a783          	lw	a5,1722(a5) # 800088fc <panicked>
    8000624a:	e7c9                	bnez	a5,800062d4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000624c:	00002717          	auipc	a4,0x2
    80006250:	6bc73703          	ld	a4,1724(a4) # 80008908 <uart_tx_w>
    80006254:	00002797          	auipc	a5,0x2
    80006258:	6ac7b783          	ld	a5,1708(a5) # 80008900 <uart_tx_r>
    8000625c:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006260:	0001c997          	auipc	s3,0x1c
    80006264:	ae898993          	add	s3,s3,-1304 # 80021d48 <uart_tx_lock>
    80006268:	00002497          	auipc	s1,0x2
    8000626c:	69848493          	add	s1,s1,1688 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006270:	00002917          	auipc	s2,0x2
    80006274:	69890913          	add	s2,s2,1688 # 80008908 <uart_tx_w>
    80006278:	00e79f63          	bne	a5,a4,80006296 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000627c:	85ce                	mv	a1,s3
    8000627e:	8526                	mv	a0,s1
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	37e080e7          	jalr	894(ra) # 800015fe <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006288:	00093703          	ld	a4,0(s2)
    8000628c:	609c                	ld	a5,0(s1)
    8000628e:	02078793          	add	a5,a5,32
    80006292:	fee785e3          	beq	a5,a4,8000627c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006296:	0001c497          	auipc	s1,0x1c
    8000629a:	ab248493          	add	s1,s1,-1358 # 80021d48 <uart_tx_lock>
    8000629e:	01f77793          	and	a5,a4,31
    800062a2:	97a6                	add	a5,a5,s1
    800062a4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800062a8:	0705                	add	a4,a4,1
    800062aa:	00002797          	auipc	a5,0x2
    800062ae:	64e7bf23          	sd	a4,1630(a5) # 80008908 <uart_tx_w>
  uartstart();
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	ede080e7          	jalr	-290(ra) # 80006190 <uartstart>
  release(&uart_tx_lock);
    800062ba:	8526                	mv	a0,s1
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	1d4080e7          	jalr	468(ra) # 80006490 <release>
}
    800062c4:	70a2                	ld	ra,40(sp)
    800062c6:	7402                	ld	s0,32(sp)
    800062c8:	64e2                	ld	s1,24(sp)
    800062ca:	6942                	ld	s2,16(sp)
    800062cc:	69a2                	ld	s3,8(sp)
    800062ce:	6a02                	ld	s4,0(sp)
    800062d0:	6145                	add	sp,sp,48
    800062d2:	8082                	ret
    for(;;)
    800062d4:	a001                	j	800062d4 <uartputc+0xb4>

00000000800062d6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062d6:	1141                	add	sp,sp,-16
    800062d8:	e422                	sd	s0,8(sp)
    800062da:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062dc:	100007b7          	lui	a5,0x10000
    800062e0:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800062e2:	0007c783          	lbu	a5,0(a5)
    800062e6:	8b85                	and	a5,a5,1
    800062e8:	cb81                	beqz	a5,800062f8 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800062ea:	100007b7          	lui	a5,0x10000
    800062ee:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062f2:	6422                	ld	s0,8(sp)
    800062f4:	0141                	add	sp,sp,16
    800062f6:	8082                	ret
    return -1;
    800062f8:	557d                	li	a0,-1
    800062fa:	bfe5                	j	800062f2 <uartgetc+0x1c>

00000000800062fc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062fc:	1101                	add	sp,sp,-32
    800062fe:	ec06                	sd	ra,24(sp)
    80006300:	e822                	sd	s0,16(sp)
    80006302:	e426                	sd	s1,8(sp)
    80006304:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006306:	54fd                	li	s1,-1
    80006308:	a029                	j	80006312 <uartintr+0x16>
      break;
    consoleintr(c);
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	8ce080e7          	jalr	-1842(ra) # 80005bd8 <consoleintr>
    int c = uartgetc();
    80006312:	00000097          	auipc	ra,0x0
    80006316:	fc4080e7          	jalr	-60(ra) # 800062d6 <uartgetc>
    if(c == -1)
    8000631a:	fe9518e3          	bne	a0,s1,8000630a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000631e:	0001c497          	auipc	s1,0x1c
    80006322:	a2a48493          	add	s1,s1,-1494 # 80021d48 <uart_tx_lock>
    80006326:	8526                	mv	a0,s1
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	0b4080e7          	jalr	180(ra) # 800063dc <acquire>
  uartstart();
    80006330:	00000097          	auipc	ra,0x0
    80006334:	e60080e7          	jalr	-416(ra) # 80006190 <uartstart>
  release(&uart_tx_lock);
    80006338:	8526                	mv	a0,s1
    8000633a:	00000097          	auipc	ra,0x0
    8000633e:	156080e7          	jalr	342(ra) # 80006490 <release>
}
    80006342:	60e2                	ld	ra,24(sp)
    80006344:	6442                	ld	s0,16(sp)
    80006346:	64a2                	ld	s1,8(sp)
    80006348:	6105                	add	sp,sp,32
    8000634a:	8082                	ret

000000008000634c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000634c:	1141                	add	sp,sp,-16
    8000634e:	e422                	sd	s0,8(sp)
    80006350:	0800                	add	s0,sp,16
  lk->name = name;
    80006352:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006354:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006358:	00053823          	sd	zero,16(a0)
}
    8000635c:	6422                	ld	s0,8(sp)
    8000635e:	0141                	add	sp,sp,16
    80006360:	8082                	ret

0000000080006362 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006362:	411c                	lw	a5,0(a0)
    80006364:	e399                	bnez	a5,8000636a <holding+0x8>
    80006366:	4501                	li	a0,0
  return r;
}
    80006368:	8082                	ret
{
    8000636a:	1101                	add	sp,sp,-32
    8000636c:	ec06                	sd	ra,24(sp)
    8000636e:	e822                	sd	s0,16(sp)
    80006370:	e426                	sd	s1,8(sp)
    80006372:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006374:	6904                	ld	s1,16(a0)
    80006376:	ffffb097          	auipc	ra,0xffffb
    8000637a:	bbe080e7          	jalr	-1090(ra) # 80000f34 <mycpu>
    8000637e:	40a48533          	sub	a0,s1,a0
    80006382:	00153513          	seqz	a0,a0
}
    80006386:	60e2                	ld	ra,24(sp)
    80006388:	6442                	ld	s0,16(sp)
    8000638a:	64a2                	ld	s1,8(sp)
    8000638c:	6105                	add	sp,sp,32
    8000638e:	8082                	ret

0000000080006390 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006390:	1101                	add	sp,sp,-32
    80006392:	ec06                	sd	ra,24(sp)
    80006394:	e822                	sd	s0,16(sp)
    80006396:	e426                	sd	s1,8(sp)
    80006398:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000639a:	100024f3          	csrr	s1,sstatus
    8000639e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063a2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063a4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063a8:	ffffb097          	auipc	ra,0xffffb
    800063ac:	b8c080e7          	jalr	-1140(ra) # 80000f34 <mycpu>
    800063b0:	5d3c                	lw	a5,120(a0)
    800063b2:	cf89                	beqz	a5,800063cc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063b4:	ffffb097          	auipc	ra,0xffffb
    800063b8:	b80080e7          	jalr	-1152(ra) # 80000f34 <mycpu>
    800063bc:	5d3c                	lw	a5,120(a0)
    800063be:	2785                	addw	a5,a5,1
    800063c0:	dd3c                	sw	a5,120(a0)
}
    800063c2:	60e2                	ld	ra,24(sp)
    800063c4:	6442                	ld	s0,16(sp)
    800063c6:	64a2                	ld	s1,8(sp)
    800063c8:	6105                	add	sp,sp,32
    800063ca:	8082                	ret
    mycpu()->intena = old;
    800063cc:	ffffb097          	auipc	ra,0xffffb
    800063d0:	b68080e7          	jalr	-1176(ra) # 80000f34 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063d4:	8085                	srl	s1,s1,0x1
    800063d6:	8885                	and	s1,s1,1
    800063d8:	dd64                	sw	s1,124(a0)
    800063da:	bfe9                	j	800063b4 <push_off+0x24>

00000000800063dc <acquire>:
{
    800063dc:	1101                	add	sp,sp,-32
    800063de:	ec06                	sd	ra,24(sp)
    800063e0:	e822                	sd	s0,16(sp)
    800063e2:	e426                	sd	s1,8(sp)
    800063e4:	1000                	add	s0,sp,32
    800063e6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	fa8080e7          	jalr	-88(ra) # 80006390 <push_off>
  if(holding(lk))
    800063f0:	8526                	mv	a0,s1
    800063f2:	00000097          	auipc	ra,0x0
    800063f6:	f70080e7          	jalr	-144(ra) # 80006362 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063fa:	4705                	li	a4,1
  if(holding(lk))
    800063fc:	e115                	bnez	a0,80006420 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063fe:	87ba                	mv	a5,a4
    80006400:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006404:	2781                	sext.w	a5,a5
    80006406:	ffe5                	bnez	a5,800063fe <acquire+0x22>
  __sync_synchronize();
    80006408:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000640c:	ffffb097          	auipc	ra,0xffffb
    80006410:	b28080e7          	jalr	-1240(ra) # 80000f34 <mycpu>
    80006414:	e888                	sd	a0,16(s1)
}
    80006416:	60e2                	ld	ra,24(sp)
    80006418:	6442                	ld	s0,16(sp)
    8000641a:	64a2                	ld	s1,8(sp)
    8000641c:	6105                	add	sp,sp,32
    8000641e:	8082                	ret
    panic("acquire");
    80006420:	00002517          	auipc	a0,0x2
    80006424:	32050513          	add	a0,a0,800 # 80008740 <etext+0x740>
    80006428:	00000097          	auipc	ra,0x0
    8000642c:	a3a080e7          	jalr	-1478(ra) # 80005e62 <panic>

0000000080006430 <pop_off>:

void
pop_off(void)
{
    80006430:	1141                	add	sp,sp,-16
    80006432:	e406                	sd	ra,8(sp)
    80006434:	e022                	sd	s0,0(sp)
    80006436:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80006438:	ffffb097          	auipc	ra,0xffffb
    8000643c:	afc080e7          	jalr	-1284(ra) # 80000f34 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006440:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006444:	8b89                	and	a5,a5,2
  if(intr_get())
    80006446:	e78d                	bnez	a5,80006470 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006448:	5d3c                	lw	a5,120(a0)
    8000644a:	02f05b63          	blez	a5,80006480 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000644e:	37fd                	addw	a5,a5,-1
    80006450:	0007871b          	sext.w	a4,a5
    80006454:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006456:	eb09                	bnez	a4,80006468 <pop_off+0x38>
    80006458:	5d7c                	lw	a5,124(a0)
    8000645a:	c799                	beqz	a5,80006468 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000645c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006460:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006464:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006468:	60a2                	ld	ra,8(sp)
    8000646a:	6402                	ld	s0,0(sp)
    8000646c:	0141                	add	sp,sp,16
    8000646e:	8082                	ret
    panic("pop_off - interruptible");
    80006470:	00002517          	auipc	a0,0x2
    80006474:	2d850513          	add	a0,a0,728 # 80008748 <etext+0x748>
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	9ea080e7          	jalr	-1558(ra) # 80005e62 <panic>
    panic("pop_off");
    80006480:	00002517          	auipc	a0,0x2
    80006484:	2e050513          	add	a0,a0,736 # 80008760 <etext+0x760>
    80006488:	00000097          	auipc	ra,0x0
    8000648c:	9da080e7          	jalr	-1574(ra) # 80005e62 <panic>

0000000080006490 <release>:
{
    80006490:	1101                	add	sp,sp,-32
    80006492:	ec06                	sd	ra,24(sp)
    80006494:	e822                	sd	s0,16(sp)
    80006496:	e426                	sd	s1,8(sp)
    80006498:	1000                	add	s0,sp,32
    8000649a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000649c:	00000097          	auipc	ra,0x0
    800064a0:	ec6080e7          	jalr	-314(ra) # 80006362 <holding>
    800064a4:	c115                	beqz	a0,800064c8 <release+0x38>
  lk->cpu = 0;
    800064a6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064aa:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064ae:	0f50000f          	fence	iorw,ow
    800064b2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064b6:	00000097          	auipc	ra,0x0
    800064ba:	f7a080e7          	jalr	-134(ra) # 80006430 <pop_off>
}
    800064be:	60e2                	ld	ra,24(sp)
    800064c0:	6442                	ld	s0,16(sp)
    800064c2:	64a2                	ld	s1,8(sp)
    800064c4:	6105                	add	sp,sp,32
    800064c6:	8082                	ret
    panic("release");
    800064c8:	00002517          	auipc	a0,0x2
    800064cc:	2a050513          	add	a0,a0,672 # 80008768 <etext+0x768>
    800064d0:	00000097          	auipc	ra,0x0
    800064d4:	992080e7          	jalr	-1646(ra) # 80005e62 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
