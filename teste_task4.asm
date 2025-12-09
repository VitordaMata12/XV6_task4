
_teste_task4:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  free(shared_mem);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "Iniciando verificacao do CoW Fork...\n");
  11:	68 b0 0a 00 00       	push   $0xab0
  16:	6a 01                	push   $0x1
  18:	e8 73 05 00 00       	call   590 <printf>

  test_simple();
  1d:	e8 1e 00 00 00       	call   40 <test_simple>
  test_stress();
  22:	e8 09 01 00 00       	call   130 <test_stress>

  printf(1, "\nTODOS OS TESTES PASSARAM!\n");
  27:	58                   	pop    %eax
  28:	5a                   	pop    %edx
  29:	68 e7 0a 00 00       	push   $0xae7
  2e:	6a 01                	push   $0x1
  30:	e8 5b 05 00 00       	call   590 <printf>
  exit();
  35:	e8 f9 03 00 00       	call   433 <exit>
  3a:	66 90                	xchg   %ax,%ax
  3c:	66 90                	xchg   %ax,%ax
  3e:	66 90                	xchg   %ax,%ax

00000040 <test_simple>:
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	83 ec 10             	sub    $0x10,%esp
  printf(1, "\n--- Iniciando Teste Simples (CoW) ---\n");
  46:	68 98 08 00 00       	push   $0x898
  4b:	6a 01                	push   $0x1
  4d:	e8 3e 05 00 00       	call   590 <printf>
  int pid = cowfork();
  52:	e8 8c 04 00 00       	call   4e3 <cowfork>
  if(pid < 0){
  57:	83 c4 10             	add    $0x10,%esp
  5a:	85 c0                	test   %eax,%eax
  5c:	0f 88 b2 00 00 00    	js     114 <test_simple+0xd4>
  if(pid == 0){
  62:	75 5c                	jne    c0 <test_simple+0x80>
    if(global_val != 50 || local_val != 100){
  64:	83 3d 58 0e 00 00 32 	cmpl   $0x32,0xe58
  6b:	74 1b                	je     88 <test_simple+0x48>
      printf(1, "ERRO: Filho leu valores incorretos antes da escrita.\n");
  6d:	83 ec 08             	sub    $0x8,%esp
  70:	68 c0 08 00 00       	push   $0x8c0
  75:	6a 01                	push   $0x1
  77:	e8 14 05 00 00       	call   590 <printf>
      exit();
  7c:	e8 b2 03 00 00       	call   433 <exit>
  81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "Filho: Tentando modificar valores...\n");
  88:	83 ec 08             	sub    $0x8,%esp
  8b:	68 f8 08 00 00       	push   $0x8f8
  90:	6a 01                	push   $0x1
  92:	e8 f9 04 00 00       	call   590 <printf>
    printf(1, "Filho: Valores modificados. Global=%d, Local=%d\n", global_val, local_val);
  97:	68 9b 00 00 00       	push   $0x9b
  9c:	6a 37                	push   $0x37
  9e:	68 20 09 00 00       	push   $0x920
  a3:	6a 01                	push   $0x1
    global_val = 55;
  a5:	c7 05 58 0e 00 00 37 	movl   $0x37,0xe58
  ac:	00 00 00 
    printf(1, "Filho: Valores modificados. Global=%d, Local=%d\n", global_val, local_val);
  af:	e8 dc 04 00 00       	call   590 <printf>
    exit();
  b4:	83 c4 20             	add    $0x20,%esp
  b7:	e8 77 03 00 00       	call   433 <exit>
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wait(); // Espera o filho terminar
  c0:	e8 76 03 00 00       	call   43b <wait>
    if(global_val == 50 && local_val == 100){
  c5:	83 3d 58 0e 00 00 32 	cmpl   $0x32,0xe58
  cc:	74 32                	je     100 <test_simple+0xc0>
      printf(1, "[TESTE 1] FALHA: Memoria do pai foi alterada pelo filho!\n");
  ce:	83 ec 08             	sub    $0x8,%esp
  d1:	68 88 09 00 00       	push   $0x988
  d6:	6a 01                	push   $0x1
  d8:	e8 b3 04 00 00       	call   590 <printf>
      printf(1, "Esperado: 50/100. Recebido: %d/%d\n", global_val, local_val);
  dd:	6a 64                	push   $0x64
  df:	ff 35 58 0e 00 00    	push   0xe58
  e5:	68 c4 09 00 00       	push   $0x9c4
  ea:	6a 01                	push   $0x1
  ec:	e8 9f 04 00 00       	call   590 <printf>
  f1:	83 c4 20             	add    $0x20,%esp
}
  f4:	c9                   	leave
  f5:	c3                   	ret
  f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  fd:	00 
  fe:	66 90                	xchg   %ax,%ax
      printf(1, "[TESTE 1] Simples: OK (Memoria do pai preservada)\n");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 54 09 00 00       	push   $0x954
 108:	6a 01                	push   $0x1
 10a:	e8 81 04 00 00       	call   590 <printf>
 10f:	83 c4 10             	add    $0x10,%esp
}
 112:	c9                   	leave
 113:	c3                   	ret
    printf(1, "Erro no cowfork\n");
 114:	50                   	push   %eax
 115:	50                   	push   %eax
 116:	68 d6 0a 00 00       	push   $0xad6
 11b:	6a 01                	push   $0x1
 11d:	e8 6e 04 00 00       	call   590 <printf>
    exit();
 122:	e8 0c 03 00 00       	call   433 <exit>
 127:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 12e:	00 
 12f:	90                   	nop

00000130 <test_stress>:
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
  for(i = 0; i < 5; i++){
 135:	31 db                	xor    %ebx,%ebx
  printf(1, "\n--- Iniciando Stress Test (Multiplos Filhos) ---\n");
 137:	83 ec 08             	sub    $0x8,%esp
 13a:	68 e8 09 00 00       	push   $0x9e8
 13f:	6a 01                	push   $0x1
 141:	e8 4a 04 00 00       	call   590 <printf>
  int *shared_mem = (int*)malloc(sizeof(int));
 146:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 14d:	e8 5e 06 00 00       	call   7b0 <malloc>
  *shared_mem = 10;
 152:	83 c4 10             	add    $0x10,%esp
 155:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
  int *shared_mem = (int*)malloc(sizeof(int));
 15b:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 5; i++){
 15d:	8d 76 00             	lea    0x0(%esi),%esi
    pid = cowfork();
 160:	e8 7e 03 00 00       	call   4e3 <cowfork>
    if(pid == 0){
 165:	89 da                	mov    %ebx,%edx
      *shared_mem = *shared_mem + (i + 1);
 167:	83 c3 01             	add    $0x1,%ebx
    if(pid == 0){
 16a:	85 c0                	test   %eax,%eax
 16c:	74 66                	je     1d4 <test_stress+0xa4>
  for(i = 0; i < 5; i++){
 16e:	83 fb 05             	cmp    $0x5,%ebx
 171:	75 ed                	jne    160 <test_stress+0x30>
    wait();
 173:	e8 c3 02 00 00       	call   43b <wait>
 178:	e8 be 02 00 00       	call   43b <wait>
 17d:	e8 b9 02 00 00       	call   43b <wait>
 182:	e8 b4 02 00 00       	call   43b <wait>
 187:	e8 af 02 00 00       	call   43b <wait>
  if(*shared_mem == 10){
 18c:	8b 06                	mov    (%esi),%eax
 18e:	83 f8 0a             	cmp    $0xa,%eax
 191:	74 2d                	je     1c0 <test_stress+0x90>
    printf(1, "[TESTE 2] FALHA: Valor do pai alterado para %d\n", *shared_mem);
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 80 0a 00 00       	push   $0xa80
 19c:	6a 01                	push   $0x1
 19e:	e8 ed 03 00 00       	call   590 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
  free(shared_mem);
 1a6:	83 ec 0c             	sub    $0xc,%esp
 1a9:	56                   	push   %esi
 1aa:	e8 71 05 00 00       	call   720 <free>
}
 1af:	83 c4 10             	add    $0x10,%esp
 1b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b5:	5b                   	pop    %ebx
 1b6:	5e                   	pop    %esi
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "[TESTE 2] Stress Test: OK (Contador de referencias funcionou)\n");
 1c0:	83 ec 08             	sub    $0x8,%esp
 1c3:	68 40 0a 00 00       	push   $0xa40
 1c8:	6a 01                	push   $0x1
 1ca:	e8 c1 03 00 00       	call   590 <printf>
 1cf:	83 c4 10             	add    $0x10,%esp
 1d2:	eb d2                	jmp    1a6 <test_stress+0x76>
      *shared_mem = *shared_mem + (i + 1);
 1d4:	03 1e                	add    (%esi),%ebx
 1d6:	89 1e                	mov    %ebx,(%esi)
      printf(1, "Filho %d terminou. Valor local: %d\n", i, *shared_mem);
 1d8:	53                   	push   %ebx
 1d9:	52                   	push   %edx
 1da:	68 1c 0a 00 00       	push   $0xa1c
 1df:	6a 01                	push   $0x1
 1e1:	e8 aa 03 00 00       	call   590 <printf>
      exit();
 1e6:	e8 48 02 00 00       	call   433 <exit>
 1eb:	66 90                	xchg   %ax,%ax
 1ed:	66 90                	xchg   %ax,%ax
 1ef:	90                   	nop

000001f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1f0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f1:	31 c0                	xor    %eax,%eax
{
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	53                   	push   %ebx
 1f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 200:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 204:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 207:	83 c0 01             	add    $0x1,%eax
 20a:	84 d2                	test   %dl,%dl
 20c:	75 f2                	jne    200 <strcpy+0x10>
    ;
  return os;
}
 20e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 211:	89 c8                	mov    %ecx,%eax
 213:	c9                   	leave
 214:	c3                   	ret
 215:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21c:	00 
 21d:	8d 76 00             	lea    0x0(%esi),%esi

00000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	8b 55 08             	mov    0x8(%ebp),%edx
 227:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 22a:	0f b6 02             	movzbl (%edx),%eax
 22d:	84 c0                	test   %al,%al
 22f:	75 17                	jne    248 <strcmp+0x28>
 231:	eb 3a                	jmp    26d <strcmp+0x4d>
 233:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 238:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 23c:	83 c2 01             	add    $0x1,%edx
 23f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 242:	84 c0                	test   %al,%al
 244:	74 1a                	je     260 <strcmp+0x40>
 246:	89 d9                	mov    %ebx,%ecx
 248:	0f b6 19             	movzbl (%ecx),%ebx
 24b:	38 c3                	cmp    %al,%bl
 24d:	74 e9                	je     238 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 24f:	29 d8                	sub    %ebx,%eax
}
 251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 254:	c9                   	leave
 255:	c3                   	ret
 256:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 25d:	00 
 25e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 260:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 264:	31 c0                	xor    %eax,%eax
 266:	29 d8                	sub    %ebx,%eax
}
 268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 26b:	c9                   	leave
 26c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 26d:	0f b6 19             	movzbl (%ecx),%ebx
 270:	31 c0                	xor    %eax,%eax
 272:	eb db                	jmp    24f <strcmp+0x2f>
 274:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27b:	00 
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <strlen>:

uint
strlen(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 286:	80 3a 00             	cmpb   $0x0,(%edx)
 289:	74 15                	je     2a0 <strlen+0x20>
 28b:	31 c0                	xor    %eax,%eax
 28d:	8d 76 00             	lea    0x0(%esi),%esi
 290:	83 c0 01             	add    $0x1,%eax
 293:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 297:	89 c1                	mov    %eax,%ecx
 299:	75 f5                	jne    290 <strlen+0x10>
    ;
  return n;
}
 29b:	89 c8                	mov    %ecx,%eax
 29d:	5d                   	pop    %ebp
 29e:	c3                   	ret
 29f:	90                   	nop
  for(n = 0; s[n]; n++)
 2a0:	31 c9                	xor    %ecx,%ecx
}
 2a2:	5d                   	pop    %ebp
 2a3:	89 c8                	mov    %ecx,%eax
 2a5:	c3                   	ret
 2a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ad:	00 
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 d7                	mov    %edx,%edi
 2bf:	fc                   	cld
 2c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2c5:	89 d0                	mov    %edx,%eax
 2c7:	c9                   	leave
 2c8:	c3                   	ret
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <strchr>:

char*
strchr(const char *s, char c)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2da:	0f b6 10             	movzbl (%eax),%edx
 2dd:	84 d2                	test   %dl,%dl
 2df:	75 12                	jne    2f3 <strchr+0x23>
 2e1:	eb 1d                	jmp    300 <strchr+0x30>
 2e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2ec:	83 c0 01             	add    $0x1,%eax
 2ef:	84 d2                	test   %dl,%dl
 2f1:	74 0d                	je     300 <strchr+0x30>
    if(*s == c)
 2f3:	38 d1                	cmp    %dl,%cl
 2f5:	75 f1                	jne    2e8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2f7:	5d                   	pop    %ebp
 2f8:	c3                   	ret
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 300:	31 c0                	xor    %eax,%eax
}
 302:	5d                   	pop    %ebp
 303:	c3                   	ret
 304:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 30b:	00 
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <gets>:

char*
gets(char *buf, int max)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 315:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 318:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 319:	31 db                	xor    %ebx,%ebx
{
 31b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 31e:	eb 27                	jmp    347 <gets+0x37>
    cc = read(0, &c, 1);
 320:	83 ec 04             	sub    $0x4,%esp
 323:	6a 01                	push   $0x1
 325:	56                   	push   %esi
 326:	6a 00                	push   $0x0
 328:	e8 1e 01 00 00       	call   44b <read>
    if(cc < 1)
 32d:	83 c4 10             	add    $0x10,%esp
 330:	85 c0                	test   %eax,%eax
 332:	7e 1d                	jle    351 <gets+0x41>
      break;
    buf[i++] = c;
 334:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 338:	8b 55 08             	mov    0x8(%ebp),%edx
 33b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 33f:	3c 0a                	cmp    $0xa,%al
 341:	74 10                	je     353 <gets+0x43>
 343:	3c 0d                	cmp    $0xd,%al
 345:	74 0c                	je     353 <gets+0x43>
  for(i=0; i+1 < max; ){
 347:	89 df                	mov    %ebx,%edi
 349:	83 c3 01             	add    $0x1,%ebx
 34c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 34f:	7c cf                	jl     320 <gets+0x10>
 351:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 35a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35d:	5b                   	pop    %ebx
 35e:	5e                   	pop    %esi
 35f:	5f                   	pop    %edi
 360:	5d                   	pop    %ebp
 361:	c3                   	ret
 362:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 369:	00 
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 375:	83 ec 08             	sub    $0x8,%esp
 378:	6a 00                	push   $0x0
 37a:	ff 75 08             	push   0x8(%ebp)
 37d:	e8 f1 00 00 00       	call   473 <open>
  if(fd < 0)
 382:	83 c4 10             	add    $0x10,%esp
 385:	85 c0                	test   %eax,%eax
 387:	78 27                	js     3b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	ff 75 0c             	push   0xc(%ebp)
 38f:	89 c3                	mov    %eax,%ebx
 391:	50                   	push   %eax
 392:	e8 f4 00 00 00       	call   48b <fstat>
  close(fd);
 397:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 39a:	89 c6                	mov    %eax,%esi
  close(fd);
 39c:	e8 ba 00 00 00       	call   45b <close>
  return r;
 3a1:	83 c4 10             	add    $0x10,%esp
}
 3a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3a7:	89 f0                	mov    %esi,%eax
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3b5:	eb ed                	jmp    3a4 <stat+0x34>
 3b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3be:	00 
 3bf:	90                   	nop

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	0f be 02             	movsbl (%edx),%eax
 3ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3d5:	77 1e                	ja     3f5 <atoi+0x35>
 3d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3de:	00 
 3df:	90                   	nop
    n = n*10 + *s++ - '0';
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ea:	0f be 02             	movsbl (%edx),%eax
 3ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
  return n;
}
 3f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f8:	89 c8                	mov    %ecx,%eax
 3fa:	c9                   	leave
 3fb:	c3                   	ret
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	8b 45 10             	mov    0x10(%ebp),%eax
 407:	8b 55 08             	mov    0x8(%ebp),%edx
 40a:	56                   	push   %esi
 40b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40e:	85 c0                	test   %eax,%eax
 410:	7e 13                	jle    425 <memmove+0x25>
 412:	01 d0                	add    %edx,%eax
  dst = vdst;
 414:	89 d7                	mov    %edx,%edi
 416:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 41d:	00 
 41e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 420:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 421:	39 f8                	cmp    %edi,%eax
 423:	75 fb                	jne    420 <memmove+0x20>
  return vdst;
}
 425:	5e                   	pop    %esi
 426:	89 d0                	mov    %edx,%eax
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret

0000042b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42b:	b8 01 00 00 00       	mov    $0x1,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <exit>:
SYSCALL(exit)
 433:	b8 02 00 00 00       	mov    $0x2,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <wait>:
SYSCALL(wait)
 43b:	b8 03 00 00 00       	mov    $0x3,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <pipe>:
SYSCALL(pipe)
 443:	b8 04 00 00 00       	mov    $0x4,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <read>:
SYSCALL(read)
 44b:	b8 05 00 00 00       	mov    $0x5,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <write>:
SYSCALL(write)
 453:	b8 10 00 00 00       	mov    $0x10,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <close>:
SYSCALL(close)
 45b:	b8 15 00 00 00       	mov    $0x15,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <kill>:
SYSCALL(kill)
 463:	b8 06 00 00 00       	mov    $0x6,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <exec>:
SYSCALL(exec)
 46b:	b8 07 00 00 00       	mov    $0x7,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <open>:
SYSCALL(open)
 473:	b8 0f 00 00 00       	mov    $0xf,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <mknod>:
SYSCALL(mknod)
 47b:	b8 11 00 00 00       	mov    $0x11,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <unlink>:
SYSCALL(unlink)
 483:	b8 12 00 00 00       	mov    $0x12,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <fstat>:
SYSCALL(fstat)
 48b:	b8 08 00 00 00       	mov    $0x8,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <link>:
SYSCALL(link)
 493:	b8 13 00 00 00       	mov    $0x13,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <mkdir>:
SYSCALL(mkdir)
 49b:	b8 14 00 00 00       	mov    $0x14,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <chdir>:
SYSCALL(chdir)
 4a3:	b8 09 00 00 00       	mov    $0x9,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <dup>:
SYSCALL(dup)
 4ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <getpid>:
SYSCALL(getpid)
 4b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <sbrk>:
SYSCALL(sbrk)
 4bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <sleep>:
SYSCALL(sleep)
 4c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <uptime>:
SYSCALL(uptime)
 4cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <mycall>:
SYSCALL(mycall)
 4d3:	b8 16 00 00 00       	mov    $0x16,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <date>:
SYSCALL(date)
 4db:	b8 17 00 00 00       	mov    $0x17,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <cowfork>:
SYSCALL(cowfork)
 4e3:	b8 18 00 00 00       	mov    $0x18,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret
 4eb:	66 90                	xchg   %ax,%ax
 4ed:	66 90                	xchg   %ax,%ax
 4ef:	90                   	nop

000004f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4f8:	89 d1                	mov    %edx,%ecx
{
 4fa:	83 ec 3c             	sub    $0x3c,%esp
 4fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 500:	85 d2                	test   %edx,%edx
 502:	0f 89 80 00 00 00    	jns    588 <printint+0x98>
 508:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 50c:	74 7a                	je     588 <printint+0x98>
    x = -xx;
 50e:	f7 d9                	neg    %ecx
    neg = 1;
 510:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 515:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 518:	31 f6                	xor    %esi,%esi
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 520:	89 c8                	mov    %ecx,%eax
 522:	31 d2                	xor    %edx,%edx
 524:	89 f7                	mov    %esi,%edi
 526:	f7 f3                	div    %ebx
 528:	8d 76 01             	lea    0x1(%esi),%esi
 52b:	0f b6 92 64 0b 00 00 	movzbl 0xb64(%edx),%edx
 532:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 536:	89 ca                	mov    %ecx,%edx
 538:	89 c1                	mov    %eax,%ecx
 53a:	39 da                	cmp    %ebx,%edx
 53c:	73 e2                	jae    520 <printint+0x30>
  if(neg)
 53e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 541:	85 c0                	test   %eax,%eax
 543:	74 07                	je     54c <printint+0x5c>
    buf[i++] = '-';
 545:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 54a:	89 f7                	mov    %esi,%edi
 54c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 54f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 552:	01 df                	add    %ebx,%edi
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 558:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 55b:	83 ec 04             	sub    $0x4,%esp
 55e:	88 45 d7             	mov    %al,-0x29(%ebp)
 561:	8d 45 d7             	lea    -0x29(%ebp),%eax
 564:	6a 01                	push   $0x1
 566:	50                   	push   %eax
 567:	56                   	push   %esi
 568:	e8 e6 fe ff ff       	call   453 <write>
  while(--i >= 0)
 56d:	89 f8                	mov    %edi,%eax
 56f:	83 c4 10             	add    $0x10,%esp
 572:	83 ef 01             	sub    $0x1,%edi
 575:	39 c3                	cmp    %eax,%ebx
 577:	75 df                	jne    558 <printint+0x68>
}
 579:	8d 65 f4             	lea    -0xc(%ebp),%esp
 57c:	5b                   	pop    %ebx
 57d:	5e                   	pop    %esi
 57e:	5f                   	pop    %edi
 57f:	5d                   	pop    %ebp
 580:	c3                   	ret
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 588:	31 c0                	xor    %eax,%eax
 58a:	eb 89                	jmp    515 <printint+0x25>
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000590 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 599:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 59c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 59f:	0f b6 1e             	movzbl (%esi),%ebx
 5a2:	83 c6 01             	add    $0x1,%esi
 5a5:	84 db                	test   %bl,%bl
 5a7:	74 67                	je     610 <printf+0x80>
 5a9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5ac:	31 d2                	xor    %edx,%edx
 5ae:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 5b1:	eb 34                	jmp    5e7 <printf+0x57>
 5b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5bb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5c0:	83 f8 25             	cmp    $0x25,%eax
 5c3:	74 18                	je     5dd <printf+0x4d>
  write(fd, &c, 1);
 5c5:	83 ec 04             	sub    $0x4,%esp
 5c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5cb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ce:	6a 01                	push   $0x1
 5d0:	50                   	push   %eax
 5d1:	57                   	push   %edi
 5d2:	e8 7c fe ff ff       	call   453 <write>
 5d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5da:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5dd:	0f b6 1e             	movzbl (%esi),%ebx
 5e0:	83 c6 01             	add    $0x1,%esi
 5e3:	84 db                	test   %bl,%bl
 5e5:	74 29                	je     610 <printf+0x80>
    c = fmt[i] & 0xff;
 5e7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5ea:	85 d2                	test   %edx,%edx
 5ec:	74 ca                	je     5b8 <printf+0x28>
      }
    } else if(state == '%'){
 5ee:	83 fa 25             	cmp    $0x25,%edx
 5f1:	75 ea                	jne    5dd <printf+0x4d>
      if(c == 'd'){
 5f3:	83 f8 25             	cmp    $0x25,%eax
 5f6:	0f 84 04 01 00 00    	je     700 <printf+0x170>
 5fc:	83 e8 63             	sub    $0x63,%eax
 5ff:	83 f8 15             	cmp    $0x15,%eax
 602:	77 1c                	ja     620 <printf+0x90>
 604:	ff 24 85 0c 0b 00 00 	jmp    *0xb0c(,%eax,4)
 60b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 610:	8d 65 f4             	lea    -0xc(%ebp),%esp
 613:	5b                   	pop    %ebx
 614:	5e                   	pop    %esi
 615:	5f                   	pop    %edi
 616:	5d                   	pop    %ebp
 617:	c3                   	ret
 618:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 61f:	00 
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	8d 55 e7             	lea    -0x19(%ebp),%edx
 626:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 62a:	6a 01                	push   $0x1
 62c:	52                   	push   %edx
 62d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 630:	57                   	push   %edi
 631:	e8 1d fe ff ff       	call   453 <write>
 636:	83 c4 0c             	add    $0xc,%esp
 639:	88 5d e7             	mov    %bl,-0x19(%ebp)
 63c:	6a 01                	push   $0x1
 63e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 641:	52                   	push   %edx
 642:	57                   	push   %edi
 643:	e8 0b fe ff ff       	call   453 <write>
        putc(fd, c);
 648:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64b:	31 d2                	xor    %edx,%edx
 64d:	eb 8e                	jmp    5dd <printf+0x4d>
 64f:	90                   	nop
        printint(fd, *ap, 16, 0);
 650:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	b9 10 00 00 00       	mov    $0x10,%ecx
 65b:	8b 13                	mov    (%ebx),%edx
 65d:	6a 00                	push   $0x0
 65f:	89 f8                	mov    %edi,%eax
        ap++;
 661:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 664:	e8 87 fe ff ff       	call   4f0 <printint>
        ap++;
 669:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 66c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66f:	31 d2                	xor    %edx,%edx
 671:	e9 67 ff ff ff       	jmp    5dd <printf+0x4d>
        s = (char*)*ap;
 676:	8b 45 d0             	mov    -0x30(%ebp),%eax
 679:	8b 18                	mov    (%eax),%ebx
        ap++;
 67b:	83 c0 04             	add    $0x4,%eax
 67e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 681:	85 db                	test   %ebx,%ebx
 683:	0f 84 87 00 00 00    	je     710 <printf+0x180>
        while(*s != 0){
 689:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 68c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 68e:	84 c0                	test   %al,%al
 690:	0f 84 47 ff ff ff    	je     5dd <printf+0x4d>
 696:	8d 55 e7             	lea    -0x19(%ebp),%edx
 699:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 69c:	89 de                	mov    %ebx,%esi
 69e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
 6a3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 6a6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6a9:	6a 01                	push   $0x1
 6ab:	53                   	push   %ebx
 6ac:	57                   	push   %edi
 6ad:	e8 a1 fd ff ff       	call   453 <write>
        while(*s != 0){
 6b2:	0f b6 06             	movzbl (%esi),%eax
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	84 c0                	test   %al,%al
 6ba:	75 e4                	jne    6a0 <printf+0x110>
      state = 0;
 6bc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6bf:	31 d2                	xor    %edx,%edx
 6c1:	e9 17 ff ff ff       	jmp    5dd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6c6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6c9:	83 ec 0c             	sub    $0xc,%esp
 6cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d1:	8b 13                	mov    (%ebx),%edx
 6d3:	6a 01                	push   $0x1
 6d5:	eb 88                	jmp    65f <printf+0xcf>
        putc(fd, *ap);
 6d7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6da:	83 ec 04             	sub    $0x4,%esp
 6dd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6e0:	8b 03                	mov    (%ebx),%eax
        ap++;
 6e2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6e5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
 6ea:	52                   	push   %edx
 6eb:	57                   	push   %edi
 6ec:	e8 62 fd ff ff       	call   453 <write>
        ap++;
 6f1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6f4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6f7:	31 d2                	xor    %edx,%edx
 6f9:	e9 df fe ff ff       	jmp    5dd <printf+0x4d>
 6fe:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 5d e7             	mov    %bl,-0x19(%ebp)
 706:	8d 55 e7             	lea    -0x19(%ebp),%edx
 709:	6a 01                	push   $0x1
 70b:	e9 31 ff ff ff       	jmp    641 <printf+0xb1>
 710:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 715:	bb 03 0b 00 00       	mov    $0xb03,%ebx
 71a:	e9 77 ff ff ff       	jmp    696 <printf+0x106>
 71f:	90                   	nop

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 5c 0e 00 00       	mov    0xe5c,%eax
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 72e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	39 c8                	cmp    %ecx,%eax
 73c:	73 32                	jae    770 <free+0x50>
 73e:	39 d1                	cmp    %edx,%ecx
 740:	72 04                	jb     746 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	39 d0                	cmp    %edx,%eax
 744:	72 32                	jb     778 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 746:	8b 73 fc             	mov    -0x4(%ebx),%esi
 749:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74c:	39 fa                	cmp    %edi,%edx
 74e:	74 30                	je     780 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 750:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 753:	8b 50 04             	mov    0x4(%eax),%edx
 756:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 759:	39 f1                	cmp    %esi,%ecx
 75b:	74 3a                	je     797 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 75d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 75f:	5b                   	pop    %ebx
  freep = p;
 760:	a3 5c 0e 00 00       	mov    %eax,0xe5c
}
 765:	5e                   	pop    %esi
 766:	5f                   	pop    %edi
 767:	5d                   	pop    %ebp
 768:	c3                   	ret
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	39 d0                	cmp    %edx,%eax
 772:	72 04                	jb     778 <free+0x58>
 774:	39 d1                	cmp    %edx,%ecx
 776:	72 ce                	jb     746 <free+0x26>
{
 778:	89 d0                	mov    %edx,%eax
 77a:	eb bc                	jmp    738 <free+0x18>
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 780:	03 72 04             	add    0x4(%edx),%esi
 783:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 12                	mov    (%edx),%edx
 78a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 793:	39 f1                	cmp    %esi,%ecx
 795:	75 c6                	jne    75d <free+0x3d>
    p->s.size += bp->s.size;
 797:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 79a:	a3 5c 0e 00 00       	mov    %eax,0xe5c
    p->s.size += bp->s.size;
 79f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7a5:	89 08                	mov    %ecx,(%eax)
}
 7a7:	5b                   	pop    %ebx
 7a8:	5e                   	pop    %esi
 7a9:	5f                   	pop    %edi
 7aa:	5d                   	pop    %ebp
 7ab:	c3                   	ret
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7bc:	8b 15 5c 0e 00 00    	mov    0xe5c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8d 78 07             	lea    0x7(%eax),%edi
 7c5:	c1 ef 03             	shr    $0x3,%edi
 7c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7cb:	85 d2                	test   %edx,%edx
 7cd:	0f 84 8d 00 00 00    	je     860 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7d5:	8b 48 04             	mov    0x4(%eax),%ecx
 7d8:	39 f9                	cmp    %edi,%ecx
 7da:	73 64                	jae    840 <malloc+0x90>
  if(nu < 4096)
 7dc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7e1:	39 df                	cmp    %ebx,%edi
 7e3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7e6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7ed:	eb 0a                	jmp    7f9 <malloc+0x49>
 7ef:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7f2:	8b 48 04             	mov    0x4(%eax),%ecx
 7f5:	39 f9                	cmp    %edi,%ecx
 7f7:	73 47                	jae    840 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f9:	89 c2                	mov    %eax,%edx
 7fb:	3b 05 5c 0e 00 00    	cmp    0xe5c,%eax
 801:	75 ed                	jne    7f0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 803:	83 ec 0c             	sub    $0xc,%esp
 806:	56                   	push   %esi
 807:	e8 af fc ff ff       	call   4bb <sbrk>
  if(p == (char*)-1)
 80c:	83 c4 10             	add    $0x10,%esp
 80f:	83 f8 ff             	cmp    $0xffffffff,%eax
 812:	74 1c                	je     830 <malloc+0x80>
  hp->s.size = nu;
 814:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 817:	83 ec 0c             	sub    $0xc,%esp
 81a:	83 c0 08             	add    $0x8,%eax
 81d:	50                   	push   %eax
 81e:	e8 fd fe ff ff       	call   720 <free>
  return freep;
 823:	8b 15 5c 0e 00 00    	mov    0xe5c,%edx
      if((p = morecore(nunits)) == 0)
 829:	83 c4 10             	add    $0x10,%esp
 82c:	85 d2                	test   %edx,%edx
 82e:	75 c0                	jne    7f0 <malloc+0x40>
        return 0;
  }
}
 830:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 833:	31 c0                	xor    %eax,%eax
}
 835:	5b                   	pop    %ebx
 836:	5e                   	pop    %esi
 837:	5f                   	pop    %edi
 838:	5d                   	pop    %ebp
 839:	c3                   	ret
 83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 840:	39 cf                	cmp    %ecx,%edi
 842:	74 4c                	je     890 <malloc+0xe0>
        p->s.size -= nunits;
 844:	29 f9                	sub    %edi,%ecx
 846:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 849:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 84c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 84f:	89 15 5c 0e 00 00    	mov    %edx,0xe5c
}
 855:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 858:	83 c0 08             	add    $0x8,%eax
}
 85b:	5b                   	pop    %ebx
 85c:	5e                   	pop    %esi
 85d:	5f                   	pop    %edi
 85e:	5d                   	pop    %ebp
 85f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 860:	c7 05 5c 0e 00 00 60 	movl   $0xe60,0xe5c
 867:	0e 00 00 
    base.s.size = 0;
 86a:	b8 60 0e 00 00       	mov    $0xe60,%eax
    base.s.ptr = freep = prevp = &base;
 86f:	c7 05 60 0e 00 00 60 	movl   $0xe60,0xe60
 876:	0e 00 00 
    base.s.size = 0;
 879:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 880:	00 00 00 
    if(p->s.size >= nunits){
 883:	e9 54 ff ff ff       	jmp    7dc <malloc+0x2c>
 888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 88f:	00 
        prevp->s.ptr = p->s.ptr;
 890:	8b 08                	mov    (%eax),%ecx
 892:	89 0a                	mov    %ecx,(%edx)
 894:	eb b9                	jmp    84f <malloc+0x9f>
