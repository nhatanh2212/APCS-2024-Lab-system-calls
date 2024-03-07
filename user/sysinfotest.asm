
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	6e6080e7          	jalr	1766(ra) # 6ee <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	add	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	b6450513          	add	a0,a0,-1180 # b80 <malloc+0x10a>
  24:	00001097          	auipc	ra,0x1
  28:	99a080e7          	jalr	-1638(ra) # 9be <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	620080e7          	jalr	1568(ra) # 64e <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	add	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	add	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	68e080e7          	jalr	1678(ra) # 6d6 <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
  58:	a019                	j	5e <countfree+0x28>
  5a:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  5e:	6505                	lui	a0,0x1
  60:	00000097          	auipc	ra,0x0
  64:	676080e7          	jalr	1654(ra) # 6d6 <sbrk>
  68:	ff2519e3          	bne	a0,s2,5a <countfree+0x24>
  }
  sinfo(&info);
  6c:	fc040513          	add	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	656080e7          	jalr	1622(ra) # 6d6 <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	64a080e7          	jalr	1610(ra) # 6d6 <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	add	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	af250513          	add	a0,a0,-1294 # b98 <malloc+0x122>
  ae:	00001097          	auipc	ra,0x1
  b2:	910080e7          	jalr	-1776(ra) # 9be <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	596080e7          	jalr	1430(ra) # 64e <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	add	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	add	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	add	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	5ea080e7          	jalr	1514(ra) # 6d6 <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	add	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	5c2080e7          	jalr	1474(ra) # 6d6 <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	add	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	add	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	a8c50513          	add	a0,a0,-1396 # bd0 <malloc+0x15a>
 14c:	00001097          	auipc	ra,0x1
 150:	872080e7          	jalr	-1934(ra) # 9be <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	4f8080e7          	jalr	1272(ra) # 64e <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	aa250513          	add	a0,a0,-1374 # c00 <malloc+0x18a>
 166:	00001097          	auipc	ra,0x1
 16a:	858080e7          	jalr	-1960(ra) # 9be <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	4de080e7          	jalr	1246(ra) # 64e <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	a5850513          	add	a0,a0,-1448 # bd0 <malloc+0x15a>
 180:	00001097          	auipc	ra,0x1
 184:	83e080e7          	jalr	-1986(ra) # 9be <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	4c4080e7          	jalr	1220(ra) # 64e <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	a6e50513          	add	a0,a0,-1426 # c00 <malloc+0x18a>
 19a:	00001097          	auipc	ra,0x1
 19e:	824080e7          	jalr	-2012(ra) # 9be <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	4aa080e7          	jalr	1194(ra) # 64e <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	a2250513          	add	a0,a0,-1502 # bd0 <malloc+0x15a>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	808080e7          	jalr	-2040(ra) # 9be <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	48e080e7          	jalr	1166(ra) # 64e <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	add	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	add	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	add	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	51a080e7          	jalr	1306(ra) # 6ee <sysinfo>
 1dc:	02054663          	bltz	a0,208 <testcall+0x40>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	eaeb1537          	lui	a0,0xeaeb1
 1e4:	b5b50513          	add	a0,a0,-1189 # ffffffffeaeb0b5b <base+0xffffffffeaeafb4b>
 1e8:	0552                	sll	a0,a0,0x14
 1ea:	050d                	add	a0,a0,3
 1ec:	0532                	sll	a0,a0,0xc
 1ee:	f5e50513          	add	a0,a0,-162
 1f2:	00000097          	auipc	ra,0x0
 1f6:	4fc080e7          	jalr	1276(ra) # 6ee <sysinfo>
 1fa:	57fd                	li	a5,-1
 1fc:	02f51363          	bne	a0,a5,222 <testcall+0x5a>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 200:	60e2                	ld	ra,24(sp)
 202:	6442                	ld	s0,16(sp)
 204:	6105                	add	sp,sp,32
 206:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 208:	00001517          	auipc	a0,0x1
 20c:	a0850513          	add	a0,a0,-1528 # c10 <malloc+0x19a>
 210:	00000097          	auipc	ra,0x0
 214:	7ae080e7          	jalr	1966(ra) # 9be <printf>
    exit(1);
 218:	4505                	li	a0,1
 21a:	00000097          	auipc	ra,0x0
 21e:	434080e7          	jalr	1076(ra) # 64e <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 222:	00001517          	auipc	a0,0x1
 226:	a0650513          	add	a0,a0,-1530 # c28 <malloc+0x1b2>
 22a:	00000097          	auipc	ra,0x0
 22e:	794080e7          	jalr	1940(ra) # 9be <printf>
    exit(1);
 232:	4505                	li	a0,1
 234:	00000097          	auipc	ra,0x0
 238:	41a080e7          	jalr	1050(ra) # 64e <exit>

000000000000023c <testproc>:

void testproc() {
 23c:	7139                	add	sp,sp,-64
 23e:	fc06                	sd	ra,56(sp)
 240:	f822                	sd	s0,48(sp)
 242:	f426                	sd	s1,40(sp)
 244:	0080                	add	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 246:	fd040513          	add	a0,s0,-48
 24a:	00000097          	auipc	ra,0x0
 24e:	db6080e7          	jalr	-586(ra) # 0 <sinfo>
  nproc = info.nproc;
 252:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 256:	00000097          	auipc	ra,0x0
 25a:	3f0080e7          	jalr	1008(ra) # 646 <fork>
  if(pid < 0){
 25e:	02054c63          	bltz	a0,296 <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 262:	ed21                	bnez	a0,2ba <testproc+0x7e>
    sinfo(&info);
 264:	fd040513          	add	a0,s0,-48
 268:	00000097          	auipc	ra,0x0
 26c:	d98080e7          	jalr	-616(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 270:	fd843583          	ld	a1,-40(s0)
 274:	00148613          	add	a2,s1,1
 278:	02c58c63          	beq	a1,a2,2b0 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 27c:	00001517          	auipc	a0,0x1
 280:	9fc50513          	add	a0,a0,-1540 # c78 <malloc+0x202>
 284:	00000097          	auipc	ra,0x0
 288:	73a080e7          	jalr	1850(ra) # 9be <printf>
      exit(1);
 28c:	4505                	li	a0,1
 28e:	00000097          	auipc	ra,0x0
 292:	3c0080e7          	jalr	960(ra) # 64e <exit>
    printf("sysinfotest: fork failed\n");
 296:	00001517          	auipc	a0,0x1
 29a:	9c250513          	add	a0,a0,-1598 # c58 <malloc+0x1e2>
 29e:	00000097          	auipc	ra,0x0
 2a2:	720080e7          	jalr	1824(ra) # 9be <printf>
    exit(1);
 2a6:	4505                	li	a0,1
 2a8:	00000097          	auipc	ra,0x0
 2ac:	3a6080e7          	jalr	934(ra) # 64e <exit>
    }
    exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	39c080e7          	jalr	924(ra) # 64e <exit>
  }
  wait(&status);
 2ba:	fcc40513          	add	a0,s0,-52
 2be:	00000097          	auipc	ra,0x0
 2c2:	398080e7          	jalr	920(ra) # 656 <wait>
  sinfo(&info);
 2c6:	fd040513          	add	a0,s0,-48
 2ca:	00000097          	auipc	ra,0x0
 2ce:	d36080e7          	jalr	-714(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2d2:	fd843583          	ld	a1,-40(s0)
 2d6:	00959763          	bne	a1,s1,2e4 <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2da:	70e2                	ld	ra,56(sp)
 2dc:	7442                	ld	s0,48(sp)
 2de:	74a2                	ld	s1,40(sp)
 2e0:	6121                	add	sp,sp,64
 2e2:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2e4:	8626                	mv	a2,s1
 2e6:	00001517          	auipc	a0,0x1
 2ea:	99250513          	add	a0,a0,-1646 # c78 <malloc+0x202>
 2ee:	00000097          	auipc	ra,0x0
 2f2:	6d0080e7          	jalr	1744(ra) # 9be <printf>
      exit(1);
 2f6:	4505                	li	a0,1
 2f8:	00000097          	auipc	ra,0x0
 2fc:	356080e7          	jalr	854(ra) # 64e <exit>

0000000000000300 <testbad>:

void testbad() {
 300:	1101                	add	sp,sp,-32
 302:	ec06                	sd	ra,24(sp)
 304:	e822                	sd	s0,16(sp)
 306:	1000                	add	s0,sp,32
  int pid = fork();
 308:	00000097          	auipc	ra,0x0
 30c:	33e080e7          	jalr	830(ra) # 646 <fork>
  int xstatus;
  
  if(pid < 0){
 310:	00054c63          	bltz	a0,328 <testbad+0x28>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 314:	e51d                	bnez	a0,342 <testbad+0x42>
      sinfo(0x0);
 316:	00000097          	auipc	ra,0x0
 31a:	cea080e7          	jalr	-790(ra) # 0 <sinfo>
      exit(0);
 31e:	4501                	li	a0,0
 320:	00000097          	auipc	ra,0x0
 324:	32e080e7          	jalr	814(ra) # 64e <exit>
    printf("sysinfotest: fork failed\n");
 328:	00001517          	auipc	a0,0x1
 32c:	93050513          	add	a0,a0,-1744 # c58 <malloc+0x1e2>
 330:	00000097          	auipc	ra,0x0
 334:	68e080e7          	jalr	1678(ra) # 9be <printf>
    exit(1);
 338:	4505                	li	a0,1
 33a:	00000097          	auipc	ra,0x0
 33e:	314080e7          	jalr	788(ra) # 64e <exit>
  }
  wait(&xstatus);
 342:	fec40513          	add	a0,s0,-20
 346:	00000097          	auipc	ra,0x0
 34a:	310080e7          	jalr	784(ra) # 656 <wait>
  if(xstatus == -1)  // kernel killed child?
 34e:	fec42583          	lw	a1,-20(s0)
 352:	57fd                	li	a5,-1
 354:	02f58063          	beq	a1,a5,374 <testbad+0x74>
    exit(0);
  else {
    printf("sysinfotest: testbad succeeded %d\n", xstatus);
 358:	00001517          	auipc	a0,0x1
 35c:	95050513          	add	a0,a0,-1712 # ca8 <malloc+0x232>
 360:	00000097          	auipc	ra,0x0
 364:	65e080e7          	jalr	1630(ra) # 9be <printf>
    exit(xstatus);
 368:	fec42503          	lw	a0,-20(s0)
 36c:	00000097          	auipc	ra,0x0
 370:	2e2080e7          	jalr	738(ra) # 64e <exit>
    exit(0);
 374:	4501                	li	a0,0
 376:	00000097          	auipc	ra,0x0
 37a:	2d8080e7          	jalr	728(ra) # 64e <exit>

000000000000037e <main>:
  }
}

int
main(int argc, char *argv[])
{
 37e:	1141                	add	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	add	s0,sp,16
  printf("sysinfotest: start\n");
 386:	00001517          	auipc	a0,0x1
 38a:	94a50513          	add	a0,a0,-1718 # cd0 <malloc+0x25a>
 38e:	00000097          	auipc	ra,0x0
 392:	630080e7          	jalr	1584(ra) # 9be <printf>
  testcall();
 396:	00000097          	auipc	ra,0x0
 39a:	e32080e7          	jalr	-462(ra) # 1c8 <testcall>
  testmem();
 39e:	00000097          	auipc	ra,0x0
 3a2:	d22080e7          	jalr	-734(ra) # c0 <testmem>
  testproc();
 3a6:	00000097          	auipc	ra,0x0
 3aa:	e96080e7          	jalr	-362(ra) # 23c <testproc>
  printf("sysinfotest: OK\n");
 3ae:	00001517          	auipc	a0,0x1
 3b2:	93a50513          	add	a0,a0,-1734 # ce8 <malloc+0x272>
 3b6:	00000097          	auipc	ra,0x0
 3ba:	608080e7          	jalr	1544(ra) # 9be <printf>
  exit(0);
 3be:	4501                	li	a0,0
 3c0:	00000097          	auipc	ra,0x0
 3c4:	28e080e7          	jalr	654(ra) # 64e <exit>

00000000000003c8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 3c8:	1141                	add	sp,sp,-16
 3ca:	e406                	sd	ra,8(sp)
 3cc:	e022                	sd	s0,0(sp)
 3ce:	0800                	add	s0,sp,16
  extern int main();
  main();
 3d0:	00000097          	auipc	ra,0x0
 3d4:	fae080e7          	jalr	-82(ra) # 37e <main>
  exit(0);
 3d8:	4501                	li	a0,0
 3da:	00000097          	auipc	ra,0x0
 3de:	274080e7          	jalr	628(ra) # 64e <exit>

00000000000003e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3e2:	1141                	add	sp,sp,-16
 3e4:	e422                	sd	s0,8(sp)
 3e6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3e8:	87aa                	mv	a5,a0
 3ea:	0585                	add	a1,a1,1 # fffffffffffff001 <base+0xffffffffffffdff1>
 3ec:	0785                	add	a5,a5,1
 3ee:	fff5c703          	lbu	a4,-1(a1)
 3f2:	fee78fa3          	sb	a4,-1(a5)
 3f6:	fb75                	bnez	a4,3ea <strcpy+0x8>
    ;
  return os;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	add	sp,sp,16
 3fc:	8082                	ret

00000000000003fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3fe:	1141                	add	sp,sp,-16
 400:	e422                	sd	s0,8(sp)
 402:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 404:	00054783          	lbu	a5,0(a0)
 408:	cb91                	beqz	a5,41c <strcmp+0x1e>
 40a:	0005c703          	lbu	a4,0(a1)
 40e:	00f71763          	bne	a4,a5,41c <strcmp+0x1e>
    p++, q++;
 412:	0505                	add	a0,a0,1
 414:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 416:	00054783          	lbu	a5,0(a0)
 41a:	fbe5                	bnez	a5,40a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 41c:	0005c503          	lbu	a0,0(a1)
}
 420:	40a7853b          	subw	a0,a5,a0
 424:	6422                	ld	s0,8(sp)
 426:	0141                	add	sp,sp,16
 428:	8082                	ret

000000000000042a <strlen>:

uint
strlen(const char *s)
{
 42a:	1141                	add	sp,sp,-16
 42c:	e422                	sd	s0,8(sp)
 42e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 430:	00054783          	lbu	a5,0(a0)
 434:	cf91                	beqz	a5,450 <strlen+0x26>
 436:	0505                	add	a0,a0,1
 438:	87aa                	mv	a5,a0
 43a:	86be                	mv	a3,a5
 43c:	0785                	add	a5,a5,1
 43e:	fff7c703          	lbu	a4,-1(a5)
 442:	ff65                	bnez	a4,43a <strlen+0x10>
 444:	40a6853b          	subw	a0,a3,a0
 448:	2505                	addw	a0,a0,1
    ;
  return n;
}
 44a:	6422                	ld	s0,8(sp)
 44c:	0141                	add	sp,sp,16
 44e:	8082                	ret
  for(n = 0; s[n]; n++)
 450:	4501                	li	a0,0
 452:	bfe5                	j	44a <strlen+0x20>

0000000000000454 <memset>:

void*
memset(void *dst, int c, uint n)
{
 454:	1141                	add	sp,sp,-16
 456:	e422                	sd	s0,8(sp)
 458:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 45a:	ca19                	beqz	a2,470 <memset+0x1c>
 45c:	87aa                	mv	a5,a0
 45e:	1602                	sll	a2,a2,0x20
 460:	9201                	srl	a2,a2,0x20
 462:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 466:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 46a:	0785                	add	a5,a5,1
 46c:	fee79de3          	bne	a5,a4,466 <memset+0x12>
  }
  return dst;
}
 470:	6422                	ld	s0,8(sp)
 472:	0141                	add	sp,sp,16
 474:	8082                	ret

0000000000000476 <strchr>:

char*
strchr(const char *s, char c)
{
 476:	1141                	add	sp,sp,-16
 478:	e422                	sd	s0,8(sp)
 47a:	0800                	add	s0,sp,16
  for(; *s; s++)
 47c:	00054783          	lbu	a5,0(a0)
 480:	cb99                	beqz	a5,496 <strchr+0x20>
    if(*s == c)
 482:	00f58763          	beq	a1,a5,490 <strchr+0x1a>
  for(; *s; s++)
 486:	0505                	add	a0,a0,1
 488:	00054783          	lbu	a5,0(a0)
 48c:	fbfd                	bnez	a5,482 <strchr+0xc>
      return (char*)s;
  return 0;
 48e:	4501                	li	a0,0
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	add	sp,sp,16
 494:	8082                	ret
  return 0;
 496:	4501                	li	a0,0
 498:	bfe5                	j	490 <strchr+0x1a>

000000000000049a <gets>:

char*
gets(char *buf, int max)
{
 49a:	711d                	add	sp,sp,-96
 49c:	ec86                	sd	ra,88(sp)
 49e:	e8a2                	sd	s0,80(sp)
 4a0:	e4a6                	sd	s1,72(sp)
 4a2:	e0ca                	sd	s2,64(sp)
 4a4:	fc4e                	sd	s3,56(sp)
 4a6:	f852                	sd	s4,48(sp)
 4a8:	f456                	sd	s5,40(sp)
 4aa:	f05a                	sd	s6,32(sp)
 4ac:	ec5e                	sd	s7,24(sp)
 4ae:	1080                	add	s0,sp,96
 4b0:	8baa                	mv	s7,a0
 4b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b4:	892a                	mv	s2,a0
 4b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4b8:	4aa9                	li	s5,10
 4ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4bc:	89a6                	mv	s3,s1
 4be:	2485                	addw	s1,s1,1
 4c0:	0344d863          	bge	s1,s4,4f0 <gets+0x56>
    cc = read(0, &c, 1);
 4c4:	4605                	li	a2,1
 4c6:	faf40593          	add	a1,s0,-81
 4ca:	4501                	li	a0,0
 4cc:	00000097          	auipc	ra,0x0
 4d0:	19a080e7          	jalr	410(ra) # 666 <read>
    if(cc < 1)
 4d4:	00a05e63          	blez	a0,4f0 <gets+0x56>
    buf[i++] = c;
 4d8:	faf44783          	lbu	a5,-81(s0)
 4dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4e0:	01578763          	beq	a5,s5,4ee <gets+0x54>
 4e4:	0905                	add	s2,s2,1
 4e6:	fd679be3          	bne	a5,s6,4bc <gets+0x22>
    buf[i++] = c;
 4ea:	89a6                	mv	s3,s1
 4ec:	a011                	j	4f0 <gets+0x56>
 4ee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4f0:	99de                	add	s3,s3,s7
 4f2:	00098023          	sb	zero,0(s3) # 1000 <freep>
  return buf;
}
 4f6:	855e                	mv	a0,s7
 4f8:	60e6                	ld	ra,88(sp)
 4fa:	6446                	ld	s0,80(sp)
 4fc:	64a6                	ld	s1,72(sp)
 4fe:	6906                	ld	s2,64(sp)
 500:	79e2                	ld	s3,56(sp)
 502:	7a42                	ld	s4,48(sp)
 504:	7aa2                	ld	s5,40(sp)
 506:	7b02                	ld	s6,32(sp)
 508:	6be2                	ld	s7,24(sp)
 50a:	6125                	add	sp,sp,96
 50c:	8082                	ret

000000000000050e <stat>:

int
stat(const char *n, struct stat *st)
{
 50e:	1101                	add	sp,sp,-32
 510:	ec06                	sd	ra,24(sp)
 512:	e822                	sd	s0,16(sp)
 514:	e04a                	sd	s2,0(sp)
 516:	1000                	add	s0,sp,32
 518:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 51a:	4581                	li	a1,0
 51c:	00000097          	auipc	ra,0x0
 520:	172080e7          	jalr	370(ra) # 68e <open>
  if(fd < 0)
 524:	02054663          	bltz	a0,550 <stat+0x42>
 528:	e426                	sd	s1,8(sp)
 52a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 52c:	85ca                	mv	a1,s2
 52e:	00000097          	auipc	ra,0x0
 532:	178080e7          	jalr	376(ra) # 6a6 <fstat>
 536:	892a                	mv	s2,a0
  close(fd);
 538:	8526                	mv	a0,s1
 53a:	00000097          	auipc	ra,0x0
 53e:	13c080e7          	jalr	316(ra) # 676 <close>
  return r;
 542:	64a2                	ld	s1,8(sp)
}
 544:	854a                	mv	a0,s2
 546:	60e2                	ld	ra,24(sp)
 548:	6442                	ld	s0,16(sp)
 54a:	6902                	ld	s2,0(sp)
 54c:	6105                	add	sp,sp,32
 54e:	8082                	ret
    return -1;
 550:	597d                	li	s2,-1
 552:	bfcd                	j	544 <stat+0x36>

0000000000000554 <atoi>:

int
atoi(const char *s)
{
 554:	1141                	add	sp,sp,-16
 556:	e422                	sd	s0,8(sp)
 558:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 55a:	00054683          	lbu	a3,0(a0)
 55e:	fd06879b          	addw	a5,a3,-48
 562:	0ff7f793          	zext.b	a5,a5
 566:	4625                	li	a2,9
 568:	02f66863          	bltu	a2,a5,598 <atoi+0x44>
 56c:	872a                	mv	a4,a0
  n = 0;
 56e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 570:	0705                	add	a4,a4,1
 572:	0025179b          	sllw	a5,a0,0x2
 576:	9fa9                	addw	a5,a5,a0
 578:	0017979b          	sllw	a5,a5,0x1
 57c:	9fb5                	addw	a5,a5,a3
 57e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 582:	00074683          	lbu	a3,0(a4)
 586:	fd06879b          	addw	a5,a3,-48
 58a:	0ff7f793          	zext.b	a5,a5
 58e:	fef671e3          	bgeu	a2,a5,570 <atoi+0x1c>
  return n;
}
 592:	6422                	ld	s0,8(sp)
 594:	0141                	add	sp,sp,16
 596:	8082                	ret
  n = 0;
 598:	4501                	li	a0,0
 59a:	bfe5                	j	592 <atoi+0x3e>

000000000000059c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 59c:	1141                	add	sp,sp,-16
 59e:	e422                	sd	s0,8(sp)
 5a0:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5a2:	02b57463          	bgeu	a0,a1,5ca <memmove+0x2e>
    while(n-- > 0)
 5a6:	00c05f63          	blez	a2,5c4 <memmove+0x28>
 5aa:	1602                	sll	a2,a2,0x20
 5ac:	9201                	srl	a2,a2,0x20
 5ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 5b4:	0585                	add	a1,a1,1
 5b6:	0705                	add	a4,a4,1
 5b8:	fff5c683          	lbu	a3,-1(a1)
 5bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5c0:	fef71ae3          	bne	a4,a5,5b4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5c4:	6422                	ld	s0,8(sp)
 5c6:	0141                	add	sp,sp,16
 5c8:	8082                	ret
    dst += n;
 5ca:	00c50733          	add	a4,a0,a2
    src += n;
 5ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5d0:	fec05ae3          	blez	a2,5c4 <memmove+0x28>
 5d4:	fff6079b          	addw	a5,a2,-1
 5d8:	1782                	sll	a5,a5,0x20
 5da:	9381                	srl	a5,a5,0x20
 5dc:	fff7c793          	not	a5,a5
 5e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5e2:	15fd                	add	a1,a1,-1
 5e4:	177d                	add	a4,a4,-1
 5e6:	0005c683          	lbu	a3,0(a1)
 5ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5ee:	fee79ae3          	bne	a5,a4,5e2 <memmove+0x46>
 5f2:	bfc9                	j	5c4 <memmove+0x28>

00000000000005f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5f4:	1141                	add	sp,sp,-16
 5f6:	e422                	sd	s0,8(sp)
 5f8:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5fa:	ca05                	beqz	a2,62a <memcmp+0x36>
 5fc:	fff6069b          	addw	a3,a2,-1
 600:	1682                	sll	a3,a3,0x20
 602:	9281                	srl	a3,a3,0x20
 604:	0685                	add	a3,a3,1
 606:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 608:	00054783          	lbu	a5,0(a0)
 60c:	0005c703          	lbu	a4,0(a1)
 610:	00e79863          	bne	a5,a4,620 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 614:	0505                	add	a0,a0,1
    p2++;
 616:	0585                	add	a1,a1,1
  while (n-- > 0) {
 618:	fed518e3          	bne	a0,a3,608 <memcmp+0x14>
  }
  return 0;
 61c:	4501                	li	a0,0
 61e:	a019                	j	624 <memcmp+0x30>
      return *p1 - *p2;
 620:	40e7853b          	subw	a0,a5,a4
}
 624:	6422                	ld	s0,8(sp)
 626:	0141                	add	sp,sp,16
 628:	8082                	ret
  return 0;
 62a:	4501                	li	a0,0
 62c:	bfe5                	j	624 <memcmp+0x30>

000000000000062e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 62e:	1141                	add	sp,sp,-16
 630:	e406                	sd	ra,8(sp)
 632:	e022                	sd	s0,0(sp)
 634:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 636:	00000097          	auipc	ra,0x0
 63a:	f66080e7          	jalr	-154(ra) # 59c <memmove>
}
 63e:	60a2                	ld	ra,8(sp)
 640:	6402                	ld	s0,0(sp)
 642:	0141                	add	sp,sp,16
 644:	8082                	ret

0000000000000646 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 646:	4885                	li	a7,1
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <exit>:
.global exit
exit:
 li a7, SYS_exit
 64e:	4889                	li	a7,2
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <wait>:
.global wait
wait:
 li a7, SYS_wait
 656:	488d                	li	a7,3
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 65e:	4891                	li	a7,4
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <read>:
.global read
read:
 li a7, SYS_read
 666:	4895                	li	a7,5
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <write>:
.global write
write:
 li a7, SYS_write
 66e:	48c1                	li	a7,16
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <close>:
.global close
close:
 li a7, SYS_close
 676:	48d5                	li	a7,21
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <kill>:
.global kill
kill:
 li a7, SYS_kill
 67e:	4899                	li	a7,6
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <exec>:
.global exec
exec:
 li a7, SYS_exec
 686:	489d                	li	a7,7
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <open>:
.global open
open:
 li a7, SYS_open
 68e:	48bd                	li	a7,15
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 696:	48c5                	li	a7,17
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 69e:	48c9                	li	a7,18
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6a6:	48a1                	li	a7,8
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <link>:
.global link
link:
 li a7, SYS_link
 6ae:	48cd                	li	a7,19
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6b6:	48d1                	li	a7,20
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6be:	48a5                	li	a7,9
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6c6:	48a9                	li	a7,10
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ce:	48ad                	li	a7,11
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d6:	48b1                	li	a7,12
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6de:	48b5                	li	a7,13
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6e6:	48b9                	li	a7,14
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 6ee:	48dd                	li	a7,23
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6f6:	1101                	add	sp,sp,-32
 6f8:	ec06                	sd	ra,24(sp)
 6fa:	e822                	sd	s0,16(sp)
 6fc:	1000                	add	s0,sp,32
 6fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 702:	4605                	li	a2,1
 704:	fef40593          	add	a1,s0,-17
 708:	00000097          	auipc	ra,0x0
 70c:	f66080e7          	jalr	-154(ra) # 66e <write>
}
 710:	60e2                	ld	ra,24(sp)
 712:	6442                	ld	s0,16(sp)
 714:	6105                	add	sp,sp,32
 716:	8082                	ret

0000000000000718 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 718:	7139                	add	sp,sp,-64
 71a:	fc06                	sd	ra,56(sp)
 71c:	f822                	sd	s0,48(sp)
 71e:	f426                	sd	s1,40(sp)
 720:	0080                	add	s0,sp,64
 722:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 724:	c299                	beqz	a3,72a <printint+0x12>
 726:	0805cb63          	bltz	a1,7bc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 72a:	2581                	sext.w	a1,a1
  neg = 0;
 72c:	4881                	li	a7,0
 72e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 732:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 734:	2601                	sext.w	a2,a2
 736:	00000517          	auipc	a0,0x0
 73a:	62a50513          	add	a0,a0,1578 # d60 <digits>
 73e:	883a                	mv	a6,a4
 740:	2705                	addw	a4,a4,1
 742:	02c5f7bb          	remuw	a5,a1,a2
 746:	1782                	sll	a5,a5,0x20
 748:	9381                	srl	a5,a5,0x20
 74a:	97aa                	add	a5,a5,a0
 74c:	0007c783          	lbu	a5,0(a5)
 750:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 754:	0005879b          	sext.w	a5,a1
 758:	02c5d5bb          	divuw	a1,a1,a2
 75c:	0685                	add	a3,a3,1
 75e:	fec7f0e3          	bgeu	a5,a2,73e <printint+0x26>
  if(neg)
 762:	00088c63          	beqz	a7,77a <printint+0x62>
    buf[i++] = '-';
 766:	fd070793          	add	a5,a4,-48
 76a:	00878733          	add	a4,a5,s0
 76e:	02d00793          	li	a5,45
 772:	fef70823          	sb	a5,-16(a4)
 776:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 77a:	02e05c63          	blez	a4,7b2 <printint+0x9a>
 77e:	f04a                	sd	s2,32(sp)
 780:	ec4e                	sd	s3,24(sp)
 782:	fc040793          	add	a5,s0,-64
 786:	00e78933          	add	s2,a5,a4
 78a:	fff78993          	add	s3,a5,-1
 78e:	99ba                	add	s3,s3,a4
 790:	377d                	addw	a4,a4,-1
 792:	1702                	sll	a4,a4,0x20
 794:	9301                	srl	a4,a4,0x20
 796:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 79a:	fff94583          	lbu	a1,-1(s2)
 79e:	8526                	mv	a0,s1
 7a0:	00000097          	auipc	ra,0x0
 7a4:	f56080e7          	jalr	-170(ra) # 6f6 <putc>
  while(--i >= 0)
 7a8:	197d                	add	s2,s2,-1
 7aa:	ff3918e3          	bne	s2,s3,79a <printint+0x82>
 7ae:	7902                	ld	s2,32(sp)
 7b0:	69e2                	ld	s3,24(sp)
}
 7b2:	70e2                	ld	ra,56(sp)
 7b4:	7442                	ld	s0,48(sp)
 7b6:	74a2                	ld	s1,40(sp)
 7b8:	6121                	add	sp,sp,64
 7ba:	8082                	ret
    x = -xx;
 7bc:	40b005bb          	negw	a1,a1
    neg = 1;
 7c0:	4885                	li	a7,1
    x = -xx;
 7c2:	b7b5                	j	72e <printint+0x16>

00000000000007c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c4:	715d                	add	sp,sp,-80
 7c6:	e486                	sd	ra,72(sp)
 7c8:	e0a2                	sd	s0,64(sp)
 7ca:	f84a                	sd	s2,48(sp)
 7cc:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ce:	0005c903          	lbu	s2,0(a1)
 7d2:	1a090a63          	beqz	s2,986 <vprintf+0x1c2>
 7d6:	fc26                	sd	s1,56(sp)
 7d8:	f44e                	sd	s3,40(sp)
 7da:	f052                	sd	s4,32(sp)
 7dc:	ec56                	sd	s5,24(sp)
 7de:	e85a                	sd	s6,16(sp)
 7e0:	e45e                	sd	s7,8(sp)
 7e2:	8aaa                	mv	s5,a0
 7e4:	8bb2                	mv	s7,a2
 7e6:	00158493          	add	s1,a1,1
  state = 0;
 7ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7ec:	02500a13          	li	s4,37
 7f0:	4b55                	li	s6,21
 7f2:	a839                	j	810 <vprintf+0x4c>
        putc(fd, c);
 7f4:	85ca                	mv	a1,s2
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	efe080e7          	jalr	-258(ra) # 6f6 <putc>
 800:	a019                	j	806 <vprintf+0x42>
    } else if(state == '%'){
 802:	01498d63          	beq	s3,s4,81c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 806:	0485                	add	s1,s1,1
 808:	fff4c903          	lbu	s2,-1(s1)
 80c:	16090763          	beqz	s2,97a <vprintf+0x1b6>
    if(state == 0){
 810:	fe0999e3          	bnez	s3,802 <vprintf+0x3e>
      if(c == '%'){
 814:	ff4910e3          	bne	s2,s4,7f4 <vprintf+0x30>
        state = '%';
 818:	89d2                	mv	s3,s4
 81a:	b7f5                	j	806 <vprintf+0x42>
      if(c == 'd'){
 81c:	13490463          	beq	s2,s4,944 <vprintf+0x180>
 820:	f9d9079b          	addw	a5,s2,-99
 824:	0ff7f793          	zext.b	a5,a5
 828:	12fb6763          	bltu	s6,a5,956 <vprintf+0x192>
 82c:	f9d9079b          	addw	a5,s2,-99
 830:	0ff7f713          	zext.b	a4,a5
 834:	12eb6163          	bltu	s6,a4,956 <vprintf+0x192>
 838:	00271793          	sll	a5,a4,0x2
 83c:	00000717          	auipc	a4,0x0
 840:	4cc70713          	add	a4,a4,1228 # d08 <malloc+0x292>
 844:	97ba                	add	a5,a5,a4
 846:	439c                	lw	a5,0(a5)
 848:	97ba                	add	a5,a5,a4
 84a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 84c:	008b8913          	add	s2,s7,8
 850:	4685                	li	a3,1
 852:	4629                	li	a2,10
 854:	000ba583          	lw	a1,0(s7)
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	ebe080e7          	jalr	-322(ra) # 718 <printint>
 862:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 864:	4981                	li	s3,0
 866:	b745                	j	806 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 868:	008b8913          	add	s2,s7,8
 86c:	4681                	li	a3,0
 86e:	4629                	li	a2,10
 870:	000ba583          	lw	a1,0(s7)
 874:	8556                	mv	a0,s5
 876:	00000097          	auipc	ra,0x0
 87a:	ea2080e7          	jalr	-350(ra) # 718 <printint>
 87e:	8bca                	mv	s7,s2
      state = 0;
 880:	4981                	li	s3,0
 882:	b751                	j	806 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 884:	008b8913          	add	s2,s7,8
 888:	4681                	li	a3,0
 88a:	4641                	li	a2,16
 88c:	000ba583          	lw	a1,0(s7)
 890:	8556                	mv	a0,s5
 892:	00000097          	auipc	ra,0x0
 896:	e86080e7          	jalr	-378(ra) # 718 <printint>
 89a:	8bca                	mv	s7,s2
      state = 0;
 89c:	4981                	li	s3,0
 89e:	b7a5                	j	806 <vprintf+0x42>
 8a0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8a2:	008b8c13          	add	s8,s7,8
 8a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8aa:	03000593          	li	a1,48
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e46080e7          	jalr	-442(ra) # 6f6 <putc>
  putc(fd, 'x');
 8b8:	07800593          	li	a1,120
 8bc:	8556                	mv	a0,s5
 8be:	00000097          	auipc	ra,0x0
 8c2:	e38080e7          	jalr	-456(ra) # 6f6 <putc>
 8c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c8:	00000b97          	auipc	s7,0x0
 8cc:	498b8b93          	add	s7,s7,1176 # d60 <digits>
 8d0:	03c9d793          	srl	a5,s3,0x3c
 8d4:	97de                	add	a5,a5,s7
 8d6:	0007c583          	lbu	a1,0(a5)
 8da:	8556                	mv	a0,s5
 8dc:	00000097          	auipc	ra,0x0
 8e0:	e1a080e7          	jalr	-486(ra) # 6f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e4:	0992                	sll	s3,s3,0x4
 8e6:	397d                	addw	s2,s2,-1
 8e8:	fe0914e3          	bnez	s2,8d0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 8ec:	8be2                	mv	s7,s8
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	6c02                	ld	s8,0(sp)
 8f2:	bf11                	j	806 <vprintf+0x42>
        s = va_arg(ap, char*);
 8f4:	008b8993          	add	s3,s7,8
 8f8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8fc:	02090163          	beqz	s2,91e <vprintf+0x15a>
        while(*s != 0){
 900:	00094583          	lbu	a1,0(s2)
 904:	c9a5                	beqz	a1,974 <vprintf+0x1b0>
          putc(fd, *s);
 906:	8556                	mv	a0,s5
 908:	00000097          	auipc	ra,0x0
 90c:	dee080e7          	jalr	-530(ra) # 6f6 <putc>
          s++;
 910:	0905                	add	s2,s2,1
        while(*s != 0){
 912:	00094583          	lbu	a1,0(s2)
 916:	f9e5                	bnez	a1,906 <vprintf+0x142>
        s = va_arg(ap, char*);
 918:	8bce                	mv	s7,s3
      state = 0;
 91a:	4981                	li	s3,0
 91c:	b5ed                	j	806 <vprintf+0x42>
          s = "(null)";
 91e:	00000917          	auipc	s2,0x0
 922:	3e290913          	add	s2,s2,994 # d00 <malloc+0x28a>
        while(*s != 0){
 926:	02800593          	li	a1,40
 92a:	bff1                	j	906 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 92c:	008b8913          	add	s2,s7,8
 930:	000bc583          	lbu	a1,0(s7)
 934:	8556                	mv	a0,s5
 936:	00000097          	auipc	ra,0x0
 93a:	dc0080e7          	jalr	-576(ra) # 6f6 <putc>
 93e:	8bca                	mv	s7,s2
      state = 0;
 940:	4981                	li	s3,0
 942:	b5d1                	j	806 <vprintf+0x42>
        putc(fd, c);
 944:	02500593          	li	a1,37
 948:	8556                	mv	a0,s5
 94a:	00000097          	auipc	ra,0x0
 94e:	dac080e7          	jalr	-596(ra) # 6f6 <putc>
      state = 0;
 952:	4981                	li	s3,0
 954:	bd4d                	j	806 <vprintf+0x42>
        putc(fd, '%');
 956:	02500593          	li	a1,37
 95a:	8556                	mv	a0,s5
 95c:	00000097          	auipc	ra,0x0
 960:	d9a080e7          	jalr	-614(ra) # 6f6 <putc>
        putc(fd, c);
 964:	85ca                	mv	a1,s2
 966:	8556                	mv	a0,s5
 968:	00000097          	auipc	ra,0x0
 96c:	d8e080e7          	jalr	-626(ra) # 6f6 <putc>
      state = 0;
 970:	4981                	li	s3,0
 972:	bd51                	j	806 <vprintf+0x42>
        s = va_arg(ap, char*);
 974:	8bce                	mv	s7,s3
      state = 0;
 976:	4981                	li	s3,0
 978:	b579                	j	806 <vprintf+0x42>
 97a:	74e2                	ld	s1,56(sp)
 97c:	79a2                	ld	s3,40(sp)
 97e:	7a02                	ld	s4,32(sp)
 980:	6ae2                	ld	s5,24(sp)
 982:	6b42                	ld	s6,16(sp)
 984:	6ba2                	ld	s7,8(sp)
    }
  }
}
 986:	60a6                	ld	ra,72(sp)
 988:	6406                	ld	s0,64(sp)
 98a:	7942                	ld	s2,48(sp)
 98c:	6161                	add	sp,sp,80
 98e:	8082                	ret

0000000000000990 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 990:	715d                	add	sp,sp,-80
 992:	ec06                	sd	ra,24(sp)
 994:	e822                	sd	s0,16(sp)
 996:	1000                	add	s0,sp,32
 998:	e010                	sd	a2,0(s0)
 99a:	e414                	sd	a3,8(s0)
 99c:	e818                	sd	a4,16(s0)
 99e:	ec1c                	sd	a5,24(s0)
 9a0:	03043023          	sd	a6,32(s0)
 9a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ac:	8622                	mv	a2,s0
 9ae:	00000097          	auipc	ra,0x0
 9b2:	e16080e7          	jalr	-490(ra) # 7c4 <vprintf>
}
 9b6:	60e2                	ld	ra,24(sp)
 9b8:	6442                	ld	s0,16(sp)
 9ba:	6161                	add	sp,sp,80
 9bc:	8082                	ret

00000000000009be <printf>:

void
printf(const char *fmt, ...)
{
 9be:	711d                	add	sp,sp,-96
 9c0:	ec06                	sd	ra,24(sp)
 9c2:	e822                	sd	s0,16(sp)
 9c4:	1000                	add	s0,sp,32
 9c6:	e40c                	sd	a1,8(s0)
 9c8:	e810                	sd	a2,16(s0)
 9ca:	ec14                	sd	a3,24(s0)
 9cc:	f018                	sd	a4,32(s0)
 9ce:	f41c                	sd	a5,40(s0)
 9d0:	03043823          	sd	a6,48(s0)
 9d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d8:	00840613          	add	a2,s0,8
 9dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9e0:	85aa                	mv	a1,a0
 9e2:	4505                	li	a0,1
 9e4:	00000097          	auipc	ra,0x0
 9e8:	de0080e7          	jalr	-544(ra) # 7c4 <vprintf>
}
 9ec:	60e2                	ld	ra,24(sp)
 9ee:	6442                	ld	s0,16(sp)
 9f0:	6125                	add	sp,sp,96
 9f2:	8082                	ret

00000000000009f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f4:	1141                	add	sp,sp,-16
 9f6:	e422                	sd	s0,8(sp)
 9f8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9fa:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fe:	00000797          	auipc	a5,0x0
 a02:	6027b783          	ld	a5,1538(a5) # 1000 <freep>
 a06:	a02d                	j	a30 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a08:	4618                	lw	a4,8(a2)
 a0a:	9f2d                	addw	a4,a4,a1
 a0c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a10:	6398                	ld	a4,0(a5)
 a12:	6310                	ld	a2,0(a4)
 a14:	a83d                	j	a52 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a16:	ff852703          	lw	a4,-8(a0)
 a1a:	9f31                	addw	a4,a4,a2
 a1c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a1e:	ff053683          	ld	a3,-16(a0)
 a22:	a091                	j	a66 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a24:	6398                	ld	a4,0(a5)
 a26:	00e7e463          	bltu	a5,a4,a2e <free+0x3a>
 a2a:	00e6ea63          	bltu	a3,a4,a3e <free+0x4a>
{
 a2e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a30:	fed7fae3          	bgeu	a5,a3,a24 <free+0x30>
 a34:	6398                	ld	a4,0(a5)
 a36:	00e6e463          	bltu	a3,a4,a3e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3a:	fee7eae3          	bltu	a5,a4,a2e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a3e:	ff852583          	lw	a1,-8(a0)
 a42:	6390                	ld	a2,0(a5)
 a44:	02059813          	sll	a6,a1,0x20
 a48:	01c85713          	srl	a4,a6,0x1c
 a4c:	9736                	add	a4,a4,a3
 a4e:	fae60de3          	beq	a2,a4,a08 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a52:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a56:	4790                	lw	a2,8(a5)
 a58:	02061593          	sll	a1,a2,0x20
 a5c:	01c5d713          	srl	a4,a1,0x1c
 a60:	973e                	add	a4,a4,a5
 a62:	fae68ae3          	beq	a3,a4,a16 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a66:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a68:	00000717          	auipc	a4,0x0
 a6c:	58f73c23          	sd	a5,1432(a4) # 1000 <freep>
}
 a70:	6422                	ld	s0,8(sp)
 a72:	0141                	add	sp,sp,16
 a74:	8082                	ret

0000000000000a76 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a76:	7139                	add	sp,sp,-64
 a78:	fc06                	sd	ra,56(sp)
 a7a:	f822                	sd	s0,48(sp)
 a7c:	f426                	sd	s1,40(sp)
 a7e:	ec4e                	sd	s3,24(sp)
 a80:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a82:	02051493          	sll	s1,a0,0x20
 a86:	9081                	srl	s1,s1,0x20
 a88:	04bd                	add	s1,s1,15
 a8a:	8091                	srl	s1,s1,0x4
 a8c:	0014899b          	addw	s3,s1,1
 a90:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a92:	00000517          	auipc	a0,0x0
 a96:	56e53503          	ld	a0,1390(a0) # 1000 <freep>
 a9a:	c915                	beqz	a0,ace <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9e:	4798                	lw	a4,8(a5)
 aa0:	08977e63          	bgeu	a4,s1,b3c <malloc+0xc6>
 aa4:	f04a                	sd	s2,32(sp)
 aa6:	e852                	sd	s4,16(sp)
 aa8:	e456                	sd	s5,8(sp)
 aaa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 aac:	8a4e                	mv	s4,s3
 aae:	0009871b          	sext.w	a4,s3
 ab2:	6685                	lui	a3,0x1
 ab4:	00d77363          	bgeu	a4,a3,aba <malloc+0x44>
 ab8:	6a05                	lui	s4,0x1
 aba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 abe:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac2:	00000917          	auipc	s2,0x0
 ac6:	53e90913          	add	s2,s2,1342 # 1000 <freep>
  if(p == (char*)-1)
 aca:	5afd                	li	s5,-1
 acc:	a091                	j	b10 <malloc+0x9a>
 ace:	f04a                	sd	s2,32(sp)
 ad0:	e852                	sd	s4,16(sp)
 ad2:	e456                	sd	s5,8(sp)
 ad4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ad6:	00000797          	auipc	a5,0x0
 ada:	53a78793          	add	a5,a5,1338 # 1010 <base>
 ade:	00000717          	auipc	a4,0x0
 ae2:	52f73123          	sd	a5,1314(a4) # 1000 <freep>
 ae6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ae8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aec:	b7c1                	j	aac <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 aee:	6398                	ld	a4,0(a5)
 af0:	e118                	sd	a4,0(a0)
 af2:	a08d                	j	b54 <malloc+0xde>
  hp->s.size = nu;
 af4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 af8:	0541                	add	a0,a0,16
 afa:	00000097          	auipc	ra,0x0
 afe:	efa080e7          	jalr	-262(ra) # 9f4 <free>
  return freep;
 b02:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b06:	c13d                	beqz	a0,b6c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b08:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b0a:	4798                	lw	a4,8(a5)
 b0c:	02977463          	bgeu	a4,s1,b34 <malloc+0xbe>
    if(p == freep)
 b10:	00093703          	ld	a4,0(s2)
 b14:	853e                	mv	a0,a5
 b16:	fef719e3          	bne	a4,a5,b08 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 b1a:	8552                	mv	a0,s4
 b1c:	00000097          	auipc	ra,0x0
 b20:	bba080e7          	jalr	-1094(ra) # 6d6 <sbrk>
  if(p == (char*)-1)
 b24:	fd5518e3          	bne	a0,s5,af4 <malloc+0x7e>
        return 0;
 b28:	4501                	li	a0,0
 b2a:	7902                	ld	s2,32(sp)
 b2c:	6a42                	ld	s4,16(sp)
 b2e:	6aa2                	ld	s5,8(sp)
 b30:	6b02                	ld	s6,0(sp)
 b32:	a03d                	j	b60 <malloc+0xea>
 b34:	7902                	ld	s2,32(sp)
 b36:	6a42                	ld	s4,16(sp)
 b38:	6aa2                	ld	s5,8(sp)
 b3a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b3c:	fae489e3          	beq	s1,a4,aee <malloc+0x78>
        p->s.size -= nunits;
 b40:	4137073b          	subw	a4,a4,s3
 b44:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b46:	02071693          	sll	a3,a4,0x20
 b4a:	01c6d713          	srl	a4,a3,0x1c
 b4e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b50:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b54:	00000717          	auipc	a4,0x0
 b58:	4aa73623          	sd	a0,1196(a4) # 1000 <freep>
      return (void*)(p + 1);
 b5c:	01078513          	add	a0,a5,16
  }
}
 b60:	70e2                	ld	ra,56(sp)
 b62:	7442                	ld	s0,48(sp)
 b64:	74a2                	ld	s1,40(sp)
 b66:	69e2                	ld	s3,24(sp)
 b68:	6121                	add	sp,sp,64
 b6a:	8082                	ret
 b6c:	7902                	ld	s2,32(sp)
 b6e:	6a42                	ld	s4,16(sp)
 b70:	6aa2                	ld	s5,8(sp)
 b72:	6b02                	ld	s6,0(sp)
 b74:	b7f5                	j	b60 <malloc+0xea>
