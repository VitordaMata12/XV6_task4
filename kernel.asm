
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 44 12 80       	mov    $0x801244d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 31 10 80       	mov    $0x801031f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 77 10 80       	push   $0x80107780
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 46 00 00       	call   80104680 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 77 10 80       	push   $0x80107787
80100097:	50                   	push   %eax
80100098:	e8 b3 44 00 00       	call   80104550 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 87 47 00 00       	call   80104870 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 a9 46 00 00       	call   80104810 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 44 00 00       	call   80104590 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 8e 77 10 80       	push   $0x8010778e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 44 00 00       	call   80104630 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 77 10 80       	push   $0x8010779f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 44 00 00       	call   80104630 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 43 00 00       	call   801045f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 46 00 00       	call   80104870 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 a2 45 00 00       	jmp    80104810 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 a6 77 10 80       	push   $0x801077a6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 cb 45 00 00       	call   80104870 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 40 00 00       	call   801042f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 38 00 00       	call   80103b20 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 15 45 00 00       	call   80104810 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 bf 44 00 00       	call   80104810 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 26 00 00       	call   80102a90 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 77 10 80       	push   $0x801077ad
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 57 7c 10 80 	movl   $0x80107c57,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 42 00 00       	call   801046a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 77 10 80       	push   $0x801077c1
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 ec 5c 00 00       	call   80106110 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 21 5c 00 00       	call   80106110 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 15 5c 00 00       	call   80106110 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 09 5c 00 00       	call   80106110 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 9a 44 00 00       	call   80104a00 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 f5 43 00 00       	call   80104970 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 c5 77 10 80       	push   $0x801077c5
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 a0 42 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 07 42 00 00       	call   80104810 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 e4 7c 10 80 	movzbl -0x7fef831c(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 93 40 00 00       	call   80104870 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 10 40 00 00       	call   80104810 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf d8 77 10 80       	mov    $0x801077d8,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 df 77 10 80       	push   $0x801077df
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 b8 3f 00 00       	call   80104870 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ff 10 80       	push   $0x8010ff20
801008ed:	e8 1e 3f 00 00       	call   80104810 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100914:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100933:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010094a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010095e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100998:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a05:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a27:	68 00 ff 10 80       	push   $0x8010ff00
80100a2c:	e8 7f 39 00 00       	call   801043b0 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 3c 3a 00 00       	jmp    80104490 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 e8 77 10 80       	push   $0x801077e8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 0b 3c 00 00       	call   80104680 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 5f 30 00 00       	call   80103b20 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 34 24 00 00       	call   80102f00 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 f1 67 00 00       	call   80107310 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 b0 65 00 00       	call   80107140 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 aa 64 00 00       	call   80107070 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 88 66 00 00       	call   80107290 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 57 23 00 00       	call   80102f70 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 1a 23 00 00       	call   80102f70 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 d9 64 00 00       	call   80107140 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 28 67 00 00       	call   801073b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 91 3e 00 00       	call   80104b60 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 80 3e 00 00       	call   80104b60 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 ad 69 00 00       	call   801076a0 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 88 65 00 00       	call   80107290 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 3c 69 00 00       	call   801076a0 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 7c 3d 00 00       	call   80104b20 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 10 61 00 00       	call   80106ee0 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 b8 64 00 00       	call   80107290 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 59 21 00 00       	call   80102f70 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 f0 77 10 80       	push   $0x801077f0
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 fc 77 10 80       	push   $0x801077fc
80100e3b:	68 60 ff 10 80       	push   $0x8010ff60
80100e40:	e8 3b 38 00 00       	call   80104680 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ff 10 80       	push   $0x8010ff60
80100e61:	e8 0a 3a 00 00       	call   80104870 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 7a 39 00 00       	call   80104810 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ff 10 80       	push   $0x8010ff60
80100eaa:	e8 61 39 00 00       	call   80104810 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ff 10 80       	push   $0x8010ff60
80100ecf:	e8 9c 39 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ff 10 80       	push   $0x8010ff60
80100eec:	e8 1f 39 00 00       	call   80104810 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 03 78 10 80       	push   $0x80107803
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ff 10 80       	push   $0x8010ff60
80100f21:	e8 4a 39 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 ff 10 80       	push   $0x8010ff60
80100f5c:	e8 af 38 00 00       	call   80104810 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 7d 38 00 00       	jmp    80104810 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 63 1f 00 00       	call   80102f00 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 b9 1f 00 00       	jmp    80102f70 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 f2 26 00 00       	call   801036c0 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 0b 78 10 80       	push   $0x8010780b
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 ce 27 00 00       	jmp    80103880 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 15 78 10 80       	push   $0x80107815
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 42 1e 00 00       	call   80102f70 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 ad 1d 00 00       	call   80102f00 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 e6 1d 00 00       	call   80102f70 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 1e 78 10 80       	push   $0x8010781e
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 92 25 00 00       	jmp    80103760 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 24 78 10 80       	push   $0x80107824
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 2e 78 10 80       	push   $0x8010782e
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 36 1e 00 00       	call   801030e0 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 9e 36 00 00       	call   80104970 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 06 1e 00 00       	call   801030e0 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 09 11 80       	push   $0x80110960
8010130a:	e8 61 35 00 00       	call   80104870 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 09 11 80       	push   $0x80110960
80101377:	e8 94 34 00 00       	call   80104810 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 09 11 80       	push   $0x80110960
801013a5:	e8 66 34 00 00       	call   80104810 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 44 78 10 80       	push   $0x80107844
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 9e 1c 00 00       	call   801030e0 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 54 78 10 80       	push   $0x80107854
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 f6 1b 00 00       	call   801030e0 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 67 78 10 80       	push   $0x80107867
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 9a 34 00 00       	call   80104a00 <memmove>
  brelse(bp);
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 7a 78 10 80       	push   $0x8010787a
80101591:	68 60 09 11 80       	push   $0x80110960
80101596:	e8 e5 30 00 00       	call   80104680 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 81 78 10 80       	push   $0x80107881
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 9c 2f 00 00       	call   80104550 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 25 11 80       	push   $0x801125b4
801015dc:	e8 1f 34 00 00       	call   80104a00 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 25 11 80    	push   0x801125cc
801015ef:	ff 35 c8 25 11 80    	push   0x801125c8
801015f5:	ff 35 c4 25 11 80    	push   0x801125c4
801015fb:	ff 35 c0 25 11 80    	push   0x801125c0
80101601:	ff 35 bc 25 11 80    	push   0x801125bc
80101607:	ff 35 b8 25 11 80    	push   0x801125b8
8010160d:	ff 35 b4 25 11 80    	push   0x801125b4
80101613:	68 f8 7c 10 80       	push   $0x80107cf8
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 bd 32 00 00       	call   80104970 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 1b 1a 00 00       	call   801030e0 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 87 78 10 80       	push   $0x80107887
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 aa 32 00 00       	call   80104a00 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 82 19 00 00       	call   801030e0 <log_write>
  brelse(bp);
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 ec 30 00 00       	call   80104870 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 7c 30 00 00       	call   80104810 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 c9 2d 00 00       	call   80104590 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 c3 31 00 00       	call   80104a00 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 9f 78 10 80       	push   $0x8010789f
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 99 78 10 80       	push   $0x80107899
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 98 2d 00 00       	call   80104630 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 3c 2d 00 00       	jmp    801045f0 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 ae 78 10 80       	push   $0x801078ae
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 ab 2c 00 00       	call   80104590 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 f1 2c 00 00       	call   801045f0 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 65 2f 00 00       	call   80104870 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 eb 2e 00 00       	jmp    80104810 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 3b 2f 00 00       	call   80104870 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 cc 2e 00 00       	call   80104810 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	83 c4 10             	add    $0x10,%esp
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 e8 2b 00 00       	call   80104630 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 91 2b 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 ae 78 10 80       	push   $0x801078ae
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 a4 2e 00 00       	call   80104a00 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 a6 2d 00 00       	call   80104a00 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 7e 14 00 00       	call   801030e0 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 8d 2d 00 00       	call   80104a70 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 2e 2d 00 00       	call   80104a70 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 c8 78 10 80       	push   $0x801078c8
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 b6 78 10 80       	push   $0x801078b6
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 61 1d 00 00       	call   80103b20 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 a1 2a 00 00       	call   80104870 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 31 2a 00 00       	call   80104810 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 c4 2b 00 00       	call   80104a00 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 8f 27 00 00       	call   80104630 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 2d 27 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 10 2b 00 00       	call   80104a00 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 06 27 00 00       	call   80104630 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 af 26 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 b6 26 00 00       	call   80104630 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 5f 26 00 00       	call   801045f0 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 ae 78 10 80       	push   $0x801078ae
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 9e 2a 00 00       	call   80104ac0 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 d7 78 10 80       	push   $0x801078d7
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 33 7b 10 80       	push   $0x80107b33
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ee:	00 
801020ef:	90                   	nop
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 ed 78 10 80       	push   $0x801078ed
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 e4 78 10 80       	push   $0x801078e4
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102199:	00 
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 ff 78 10 80       	push   $0x801078ff
801021ab:	68 00 26 11 80       	push   $0x80112600
801021b0:	e8 cb 24 00 00       	call   80104680 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 07 12 80       	mov    0x80120784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021fd:	00 
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102228:	00 
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 26 11 80       	push   $0x80112600
8010223e:	e8 2d 26 00 00       	call   80104870 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 0e 21 00 00       	call   801043b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 26 11 80       	push   $0x80112600
801022bb:	e8 50 25 00 00       	call   80104810 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cf:	00 

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 4d 23 00 00       	call   80104630 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 26 11 80       	push   $0x80112600
80102318:	e8 53 25 00 00       	call   80104870 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 26 11 80       	push   $0x80112600
80102358:	53                   	push   %ebx
80102359:	e8 92 1f 00 00       	call   801042f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 95 24 00 00       	jmp    80104810 <release>
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 2e 79 10 80       	push   $0x8010792e
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 19 79 10 80       	push   $0x80107919
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 03 79 10 80       	push   $0x80107903
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 07 12 80 	movzbl 0x80120780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 4c 7d 10 80       	push   $0x80107d4c
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024a8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801024ae:	0f 85 11 01 00 00    	jne    801025c5 <kfree+0x125>
801024b4:	81 fe d0 44 12 80    	cmp    $0x801244d0,%esi
801024ba:	0f 82 05 01 00 00    	jb     801025c5 <kfree+0x125>
801024c0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801024c6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801024cc:	0f 87 f3 00 00 00    	ja     801025c5 <kfree+0x125>
    panic("kfree");

  // --- INICIO DA CORREÇÃO ---
  // Só usamos lock se a inicialização já tiver ativado eles (kmem.use_lock)
  if(kmem.use_lock)
801024d2:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801024d8:	85 c9                	test   %ecx,%ecx
801024da:	75 64                	jne    80102540 <kfree+0xa0>
    acquire(&kmem.lock);

  if(kmem.ref_count[V2P(v) >> PGSHIFT] > 1){
801024dc:	c1 eb 0c             	shr    $0xc,%ebx
801024df:	0f b6 83 7c 26 11 80 	movzbl -0x7feed984(%ebx),%eax
801024e6:	3c 01                	cmp    $0x1,%al
801024e8:	77 46                	ja     80102530 <kfree+0x90>
    if(kmem.use_lock)
      release(&kmem.lock);
    return;
  }
  
  kmem.ref_count[V2P(v) >> PGSHIFT] = 0;
801024ea:	c6 83 7c 26 11 80 00 	movb   $0x0,-0x7feed984(%ebx)
  if(kmem.use_lock)
    release(&kmem.lock);
  // --- FIM DA CORREÇÃO ---

  // Preenche com lixo para pegar referências soltas (dangling refs)
  memset(v, 1, PGSIZE);
801024f1:	83 ec 04             	sub    $0x4,%esp
801024f4:	68 00 10 00 00       	push   $0x1000
801024f9:	6a 01                	push   $0x1
801024fb:	56                   	push   %esi
801024fc:	e8 6f 24 00 00       	call   80104970 <memset>

  if(kmem.use_lock)
80102501:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102507:	83 c4 10             	add    $0x10,%esp
8010250a:	85 d2                	test   %edx,%edx
8010250c:	0f 85 9e 00 00 00    	jne    801025b0 <kfree+0x110>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102512:	a1 78 26 11 80       	mov    0x80112678,%eax
80102517:	89 06                	mov    %eax,(%esi)
  kmem.freelist = r;
  if(kmem.use_lock)
80102519:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
8010251e:	89 35 78 26 11 80    	mov    %esi,0x80112678
  if(kmem.use_lock)
80102524:	85 c0                	test   %eax,%eax
80102526:	75 49                	jne    80102571 <kfree+0xd1>
    release(&kmem.lock);
}
80102528:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010252b:	5b                   	pop    %ebx
8010252c:	5e                   	pop    %esi
8010252d:	5d                   	pop    %ebp
8010252e:	c3                   	ret
8010252f:	90                   	nop
    kmem.ref_count[V2P(v) >> PGSHIFT]--;
80102530:	83 e8 01             	sub    $0x1,%eax
80102533:	88 83 7c 26 11 80    	mov    %al,-0x7feed984(%ebx)
}
80102539:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010253c:	5b                   	pop    %ebx
8010253d:	5e                   	pop    %esi
8010253e:	5d                   	pop    %ebp
8010253f:	c3                   	ret
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
  if(kmem.ref_count[V2P(v) >> PGSHIFT] > 1){
80102543:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102546:	68 40 26 11 80       	push   $0x80112640
8010254b:	e8 20 23 00 00       	call   80104870 <acquire>
  if(kmem.ref_count[V2P(v) >> PGSHIFT] > 1){
80102550:	0f b6 83 7c 26 11 80 	movzbl -0x7feed984(%ebx),%eax
    if(kmem.use_lock)
80102557:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(kmem.ref_count[V2P(v) >> PGSHIFT] > 1){
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	3c 01                	cmp    $0x1,%al
80102562:	76 24                	jbe    80102588 <kfree+0xe8>
    kmem.ref_count[V2P(v) >> PGSHIFT]--;
80102564:	83 e8 01             	sub    $0x1,%eax
80102567:	88 83 7c 26 11 80    	mov    %al,-0x7feed984(%ebx)
    if(kmem.use_lock)
8010256d:	85 d2                	test   %edx,%edx
8010256f:	74 b7                	je     80102528 <kfree+0x88>
      release(&kmem.lock);
80102571:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102578:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010257b:	5b                   	pop    %ebx
8010257c:	5e                   	pop    %esi
8010257d:	5d                   	pop    %ebp
      release(&kmem.lock);
8010257e:	e9 8d 22 00 00       	jmp    80104810 <release>
80102583:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  kmem.ref_count[V2P(v) >> PGSHIFT] = 0;
80102588:	c6 83 7c 26 11 80 00 	movb   $0x0,-0x7feed984(%ebx)
  if(kmem.use_lock)
8010258f:	85 d2                	test   %edx,%edx
80102591:	0f 84 5a ff ff ff    	je     801024f1 <kfree+0x51>
    release(&kmem.lock);
80102597:	83 ec 0c             	sub    $0xc,%esp
8010259a:	68 40 26 11 80       	push   $0x80112640
8010259f:	e8 6c 22 00 00       	call   80104810 <release>
801025a4:	83 c4 10             	add    $0x10,%esp
801025a7:	e9 45 ff ff ff       	jmp    801024f1 <kfree+0x51>
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801025b0:	83 ec 0c             	sub    $0xc,%esp
801025b3:	68 40 26 11 80       	push   $0x80112640
801025b8:	e8 b3 22 00 00       	call   80104870 <acquire>
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	e9 4d ff ff ff       	jmp    80102512 <kfree+0x72>
    panic("kfree");
801025c5:	83 ec 0c             	sub    $0xc,%esp
801025c8:	68 4c 79 10 80       	push   $0x8010794c
801025cd:	e8 ae dd ff ff       	call   80100380 <panic>
801025d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025d9:	00 
801025da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025e0 <freerange>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <freerange+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 83 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <freerange+0x28>
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret
8010262b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102630 <kinit2>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102638:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010263b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102641:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102647:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264d:	39 de                	cmp    %ebx,%esi
8010264f:	72 23                	jb     80102674 <kinit2+0x44>
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 33 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <kinit2+0x28>
  kmem.use_lock = 1;
80102674:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010267b:	00 00 00 
}
8010267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret
80102685:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268c:	00 
8010268d:	8d 76 00             	lea    0x0(%esi),%esi

80102690 <kinit1>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
80102695:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	68 52 79 10 80       	push   $0x80107952
801026a0:	68 40 26 11 80       	push   $0x80112640
801026a5:	e8 d6 1f 00 00       	call   80104680 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cc:	39 de                	cmp    %ebx,%esi
801026ce:	72 1c                	jb     801026ec <kinit1+0x5c>
    kfree(p);
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026df:	50                   	push   %eax
801026e0:	e8 bb fd ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e5:	83 c4 10             	add    $0x10,%esp
801026e8:	39 de                	cmp    %ebx,%esi
801026ea:	73 e4                	jae    801026d0 <kinit1+0x40>
}
801026ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ef:	5b                   	pop    %ebx
801026f0:	5e                   	pop    %esi
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret
801026f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026fa:	00 
801026fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102700 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102707:	a1 74 26 11 80       	mov    0x80112674,%eax
8010270c:	85 c0                	test   %eax,%eax
8010270e:	75 30                	jne    80102740 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102710:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r){
80102716:	85 db                	test   %ebx,%ebx
80102718:	74 17                	je     80102731 <kalloc+0x31>
    kmem.freelist = r->next;
8010271a:	8b 03                	mov    (%ebx),%eax
8010271c:	a3 78 26 11 80       	mov    %eax,0x80112678
    // IMPORTANTE: Inicializa contador como 1
    kmem.ref_count[V2P((char*)r) >> PGSHIFT] = 1;
80102721:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102727:	c1 e8 0c             	shr    $0xc,%eax
8010272a:	c6 80 7c 26 11 80 01 	movb   $0x1,-0x7feed984(%eax)
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102731:	89 d8                	mov    %ebx,%eax
80102733:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102736:	c9                   	leave
80102737:	c3                   	ret
80102738:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010273f:	00 
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 40 26 11 80       	push   $0x80112640
80102748:	e8 23 21 00 00       	call   80104870 <acquire>
  r = kmem.freelist;
8010274d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102753:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r){
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	85 db                	test   %ebx,%ebx
8010275e:	74 17                	je     80102777 <kalloc+0x77>
    kmem.freelist = r->next;
80102760:	8b 03                	mov    (%ebx),%eax
80102762:	a3 78 26 11 80       	mov    %eax,0x80112678
    kmem.ref_count[V2P((char*)r) >> PGSHIFT] = 1;
80102767:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010276d:	c1 e8 0c             	shr    $0xc,%eax
80102770:	c6 80 7c 26 11 80 01 	movb   $0x1,-0x7feed984(%eax)
  if(kmem.use_lock)
80102777:	85 d2                	test   %edx,%edx
80102779:	74 b6                	je     80102731 <kalloc+0x31>
    release(&kmem.lock);
8010277b:	83 ec 0c             	sub    $0xc,%esp
8010277e:	68 40 26 11 80       	push   $0x80112640
80102783:	e8 88 20 00 00       	call   80104810 <release>
}
80102788:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010278a:	83 c4 10             	add    $0x10,%esp
}
8010278d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102790:	c9                   	leave
80102791:	c3                   	ret
80102792:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102799:	00 
8010279a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027a0 <inc_ref>:


// Funções auxiliares para contagem de referências
void
inc_ref(uint pa)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	53                   	push   %ebx
801027a4:	83 ec 04             	sub    $0x4,%esp
801027a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(pa >= PHYSTOP) return;
801027aa:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801027b0:	76 0e                	jbe    801027c0 <inc_ref+0x20>
  
  acquire(&kmem.lock);
  kmem.ref_count[pa >> PGSHIFT]++;
  release(&kmem.lock);
}
801027b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b5:	c9                   	leave
801027b6:	c3                   	ret
801027b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027be:	00 
801027bf:	90                   	nop
  acquire(&kmem.lock);
801027c0:	83 ec 0c             	sub    $0xc,%esp
  kmem.ref_count[pa >> PGSHIFT]++;
801027c3:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&kmem.lock);
801027c6:	68 40 26 11 80       	push   $0x80112640
801027cb:	e8 a0 20 00 00       	call   80104870 <acquire>
  kmem.ref_count[pa >> PGSHIFT]++;
801027d0:	80 83 7c 26 11 80 01 	addb   $0x1,-0x7feed984(%ebx)
  release(&kmem.lock);
801027d7:	83 c4 10             	add    $0x10,%esp
}
801027da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&kmem.lock);
801027dd:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801027e4:	c9                   	leave
  release(&kmem.lock);
801027e5:	e9 26 20 00 00       	jmp    80104810 <release>
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027f0 <dec_ref>:

void
dec_ref(uint pa)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	53                   	push   %ebx
801027f4:	83 ec 04             	sub    $0x4,%esp
801027f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(pa >= PHYSTOP) return;
801027fa:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102800:	76 0e                	jbe    80102810 <dec_ref+0x20>
  
  acquire(&kmem.lock);
  if(kmem.ref_count[pa >> PGSHIFT] > 0)
    kmem.ref_count[pa >> PGSHIFT]--;
  release(&kmem.lock);
}
80102802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102805:	c9                   	leave
80102806:	c3                   	ret
80102807:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010280e:	00 
8010280f:	90                   	nop
  acquire(&kmem.lock);
80102810:	83 ec 0c             	sub    $0xc,%esp
  if(kmem.ref_count[pa >> PGSHIFT] > 0)
80102813:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&kmem.lock);
80102816:	68 40 26 11 80       	push   $0x80112640
8010281b:	e8 50 20 00 00       	call   80104870 <acquire>
  if(kmem.ref_count[pa >> PGSHIFT] > 0)
80102820:	0f b6 83 7c 26 11 80 	movzbl -0x7feed984(%ebx),%eax
80102827:	83 c4 10             	add    $0x10,%esp
8010282a:	84 c0                	test   %al,%al
8010282c:	74 09                	je     80102837 <dec_ref+0x47>
    kmem.ref_count[pa >> PGSHIFT]--;
8010282e:	83 e8 01             	sub    $0x1,%eax
80102831:	88 83 7c 26 11 80    	mov    %al,-0x7feed984(%ebx)
  release(&kmem.lock);
80102837:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010283e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102841:	c9                   	leave
  release(&kmem.lock);
80102842:	e9 c9 1f 00 00       	jmp    80104810 <release>
80102847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010284e:	00 
8010284f:	90                   	nop

80102850 <get_ref>:

int
get_ref(uint pa)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	56                   	push   %esi
80102854:	31 f6                	xor    %esi,%esi
80102856:	53                   	push   %ebx
80102857:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int count;
  if(pa >= PHYSTOP) return 0;
8010285a:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102860:	77 26                	ja     80102888 <get_ref+0x38>
  
  acquire(&kmem.lock);
80102862:	83 ec 0c             	sub    $0xc,%esp
  count = kmem.ref_count[pa >> PGSHIFT];
80102865:	c1 eb 0c             	shr    $0xc,%ebx
  acquire(&kmem.lock);
80102868:	68 40 26 11 80       	push   $0x80112640
8010286d:	e8 fe 1f 00 00       	call   80104870 <acquire>
  count = kmem.ref_count[pa >> PGSHIFT];
80102872:	0f b6 b3 7c 26 11 80 	movzbl -0x7feed984(%ebx),%esi
  release(&kmem.lock);
80102879:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102880:	e8 8b 1f 00 00       	call   80104810 <release>
  return count;
80102885:	83 c4 10             	add    $0x10,%esp
}
80102888:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010288b:	89 f0                	mov    %esi,%eax
8010288d:	5b                   	pop    %ebx
8010288e:	5e                   	pop    %esi
8010288f:	5d                   	pop    %ebp
80102890:	c3                   	ret
80102891:	66 90                	xchg   %ax,%ax
80102893:	66 90                	xchg   %ax,%ax
80102895:	66 90                	xchg   %ax,%ax
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	ba 64 00 00 00       	mov    $0x64,%edx
801028a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028a6:	a8 01                	test   $0x1,%al
801028a8:	0f 84 c2 00 00 00    	je     80102970 <kbdgetc+0xd0>
{
801028ae:	55                   	push   %ebp
801028af:	ba 60 00 00 00       	mov    $0x60,%edx
801028b4:	89 e5                	mov    %esp,%ebp
801028b6:	53                   	push   %ebx
801028b7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028b8:	8b 1d 7c 06 12 80    	mov    0x8012067c,%ebx
  data = inb(KBDATAP);
801028be:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028c1:	3c e0                	cmp    $0xe0,%al
801028c3:	74 5b                	je     80102920 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028c5:	89 da                	mov    %ebx,%edx
801028c7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028ca:	84 c0                	test   %al,%al
801028cc:	78 62                	js     80102930 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028ce:	85 d2                	test   %edx,%edx
801028d0:	74 09                	je     801028db <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028d2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028d5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028d8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801028db:	0f b6 91 e0 7f 10 80 	movzbl -0x7fef8020(%ecx),%edx
  shift ^= togglecode[data];
801028e2:	0f b6 81 e0 7e 10 80 	movzbl -0x7fef8120(%ecx),%eax
  shift |= shiftcode[data];
801028e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801028eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801028ef:	89 15 7c 06 12 80    	mov    %edx,0x8012067c
  c = charcode[shift & (CTL | SHIFT)][data];
801028f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028fb:	8b 04 85 c0 7e 10 80 	mov    -0x7fef8140(,%eax,4),%eax
80102902:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102906:	74 0b                	je     80102913 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102908:	8d 50 9f             	lea    -0x61(%eax),%edx
8010290b:	83 fa 19             	cmp    $0x19,%edx
8010290e:	77 48                	ja     80102958 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102910:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102916:	c9                   	leave
80102917:	c3                   	ret
80102918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010291f:	00 
    shift |= E0ESC;
80102920:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102923:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102925:	89 1d 7c 06 12 80    	mov    %ebx,0x8012067c
}
8010292b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010292e:	c9                   	leave
8010292f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102930:	83 e0 7f             	and    $0x7f,%eax
80102933:	85 d2                	test   %edx,%edx
80102935:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102938:	0f b6 81 e0 7f 10 80 	movzbl -0x7fef8020(%ecx),%eax
8010293f:	83 c8 40             	or     $0x40,%eax
80102942:	0f b6 c0             	movzbl %al,%eax
80102945:	f7 d0                	not    %eax
80102947:	21 d8                	and    %ebx,%eax
80102949:	a3 7c 06 12 80       	mov    %eax,0x8012067c
    return 0;
8010294e:	31 c0                	xor    %eax,%eax
80102950:	eb d9                	jmp    8010292b <kbdgetc+0x8b>
80102952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102958:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010295b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010295e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102961:	c9                   	leave
      c += 'a' - 'A';
80102962:	83 f9 1a             	cmp    $0x1a,%ecx
80102965:	0f 42 c2             	cmovb  %edx,%eax
}
80102968:	c3                   	ret
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102975:	c3                   	ret
80102976:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010297d:	00 
8010297e:	66 90                	xchg   %ax,%ax

80102980 <kbdintr>:

void
kbdintr(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102986:	68 a0 28 10 80       	push   $0x801028a0
8010298b:	e8 10 df ff ff       	call   801008a0 <consoleintr>
}
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	c9                   	leave
80102994:	c3                   	ret
80102995:	66 90                	xchg   %ax,%ax
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029a0:	a1 80 06 12 80       	mov    0x80120680,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	0f 84 c3 00 00 00    	je     80102a70 <lapicinit+0xd0>
  lapic[index] = value;
801029ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029fb:	8b 50 30             	mov    0x30(%eax),%edx
801029fe:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102a04:	75 72                	jne    80102a78 <lapicinit+0xd8>
  lapic[index] = value;
80102a06:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a20:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a2d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a47:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a4e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a51:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a58:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a5e:	80 e6 10             	and    $0x10,%dh
80102a61:	75 f5                	jne    80102a58 <lapicinit+0xb8>
  lapic[index] = value;
80102a63:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a70:	c3                   	ret
80102a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a78:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a7f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a82:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a85:	e9 7c ff ff ff       	jmp    80102a06 <lapicinit+0x66>
80102a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a90:	a1 80 06 12 80       	mov    0x80120680,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	74 07                	je     80102aa0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a99:	8b 40 20             	mov    0x20(%eax),%eax
80102a9c:	c1 e8 18             	shr    $0x18,%eax
80102a9f:	c3                   	ret
    return 0;
80102aa0:	31 c0                	xor    %eax,%eax
}
80102aa2:	c3                   	ret
80102aa3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102aaa:	00 
80102aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102ab0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ab0:	a1 80 06 12 80       	mov    0x80120680,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	74 0d                	je     80102ac6 <lapiceoi+0x16>
  lapic[index] = value;
80102ab9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ac0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ac6:	c3                   	ret
80102ac7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ace:	00 
80102acf:	90                   	nop

80102ad0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ad0:	c3                   	ret
80102ad1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ad8:	00 
80102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ae0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ae0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	53                   	push   %ebx
80102aee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102af4:	ee                   	out    %al,(%dx)
80102af5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102afa:	ba 71 00 00 00       	mov    $0x71,%edx
80102aff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b00:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102b02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102b10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b1e:	a1 80 06 12 80       	mov    0x80120680,%eax
80102b23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b6d:	c9                   	leave
80102b6e:	c3                   	ret
80102b6f:	90                   	nop

80102b70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b70:	55                   	push   %ebp
80102b71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b76:	ba 70 00 00 00       	mov    $0x70,%edx
80102b7b:	89 e5                	mov    %esp,%ebp
80102b7d:	57                   	push   %edi
80102b7e:	56                   	push   %esi
80102b7f:	53                   	push   %ebx
80102b80:	83 ec 4c             	sub    $0x4c,%esp
80102b83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b84:	ba 71 00 00 00       	mov    $0x71,%edx
80102b89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8d:	bf 70 00 00 00       	mov    $0x70,%edi
80102b92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b95:	8d 76 00             	lea    0x0(%esi),%esi
80102b98:	31 c0                	xor    %eax,%eax
80102b9a:	89 fa                	mov    %edi,%edx
80102b9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ba2:	89 ca                	mov    %ecx,%edx
80102ba4:	ec                   	in     (%dx),%al
80102ba5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba8:	89 fa                	mov    %edi,%edx
80102baa:	b8 02 00 00 00       	mov    $0x2,%eax
80102baf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb0:	89 ca                	mov    %ecx,%edx
80102bb2:	ec                   	in     (%dx),%al
80102bb3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb6:	89 fa                	mov    %edi,%edx
80102bb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbe:	89 ca                	mov    %ecx,%edx
80102bc0:	ec                   	in     (%dx),%al
80102bc1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc4:	89 fa                	mov    %edi,%edx
80102bc6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bcb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcc:	89 ca                	mov    %ecx,%edx
80102bce:	ec                   	in     (%dx),%al
80102bcf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd2:	89 fa                	mov    %edi,%edx
80102bd4:	b8 08 00 00 00       	mov    $0x8,%eax
80102bd9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bda:	89 ca                	mov    %ecx,%edx
80102bdc:	ec                   	in     (%dx),%al
80102bdd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bdf:	89 fa                	mov    %edi,%edx
80102be1:	b8 09 00 00 00       	mov    $0x9,%eax
80102be6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be7:	89 ca                	mov    %ecx,%edx
80102be9:	ec                   	in     (%dx),%al
80102bea:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bed:	89 fa                	mov    %edi,%edx
80102bef:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bf4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf5:	89 ca                	mov    %ecx,%edx
80102bf7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bf8:	84 c0                	test   %al,%al
80102bfa:	78 9c                	js     80102b98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bfc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c00:	89 f2                	mov    %esi,%edx
80102c02:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102c05:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c08:	89 fa                	mov    %edi,%edx
80102c0a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c0d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c11:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102c14:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c17:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c1b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c1e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c25:	31 c0                	xor    %eax,%eax
80102c27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c28:	89 ca                	mov    %ecx,%edx
80102c2a:	ec                   	in     (%dx),%al
80102c2b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2e:	89 fa                	mov    %edi,%edx
80102c30:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c33:	b8 02 00 00 00       	mov    $0x2,%eax
80102c38:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c39:	89 ca                	mov    %ecx,%edx
80102c3b:	ec                   	in     (%dx),%al
80102c3c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c3f:	89 fa                	mov    %edi,%edx
80102c41:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c44:	b8 04 00 00 00       	mov    $0x4,%eax
80102c49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4a:	89 ca                	mov    %ecx,%edx
80102c4c:	ec                   	in     (%dx),%al
80102c4d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c50:	89 fa                	mov    %edi,%edx
80102c52:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c55:	b8 07 00 00 00       	mov    $0x7,%eax
80102c5a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5b:	89 ca                	mov    %ecx,%edx
80102c5d:	ec                   	in     (%dx),%al
80102c5e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c61:	89 fa                	mov    %edi,%edx
80102c63:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c66:	b8 08 00 00 00       	mov    $0x8,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 fa                	mov    %edi,%edx
80102c74:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c77:	b8 09 00 00 00       	mov    $0x9,%eax
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
80102c80:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c83:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c89:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c8c:	6a 18                	push   $0x18
80102c8e:	50                   	push   %eax
80102c8f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c92:	50                   	push   %eax
80102c93:	e8 18 1d 00 00       	call   801049b0 <memcmp>
80102c98:	83 c4 10             	add    $0x10,%esp
80102c9b:	85 c0                	test   %eax,%eax
80102c9d:	0f 85 f5 fe ff ff    	jne    80102b98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ca3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102caa:	89 f0                	mov    %esi,%eax
80102cac:	84 c0                	test   %al,%al
80102cae:	75 78                	jne    80102d28 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cb3:	89 c2                	mov    %eax,%edx
80102cb5:	83 e0 0f             	and    $0xf,%eax
80102cb8:	c1 ea 04             	shr    $0x4,%edx
80102cbb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cbe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cc1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cc4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cc7:	89 c2                	mov    %eax,%edx
80102cc9:	83 e0 0f             	and    $0xf,%eax
80102ccc:	c1 ea 04             	shr    $0x4,%edx
80102ccf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cd8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cdb:	89 c2                	mov    %eax,%edx
80102cdd:	83 e0 0f             	and    $0xf,%eax
80102ce0:	c1 ea 04             	shr    $0x4,%edx
80102ce3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ce6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cef:	89 c2                	mov    %eax,%edx
80102cf1:	83 e0 0f             	and    $0xf,%eax
80102cf4:	c1 ea 04             	shr    $0x4,%edx
80102cf7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfa:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d00:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d03:	89 c2                	mov    %eax,%edx
80102d05:	83 e0 0f             	and    $0xf,%eax
80102d08:	c1 ea 04             	shr    $0x4,%edx
80102d0b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d11:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d14:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d17:	89 c2                	mov    %eax,%edx
80102d19:	83 e0 0f             	and    $0xf,%eax
80102d1c:	c1 ea 04             	shr    $0x4,%edx
80102d1f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d22:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d25:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d2b:	89 03                	mov    %eax,(%ebx)
80102d2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d30:	89 43 04             	mov    %eax,0x4(%ebx)
80102d33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d36:	89 43 08             	mov    %eax,0x8(%ebx)
80102d39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d3c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102d3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d42:	89 43 10             	mov    %eax,0x10(%ebx)
80102d45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d48:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102d4b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d55:	5b                   	pop    %ebx
80102d56:	5e                   	pop    %esi
80102d57:	5f                   	pop    %edi
80102d58:	5d                   	pop    %ebp
80102d59:	c3                   	ret
80102d5a:	66 90                	xchg   %ax,%ax
80102d5c:	66 90                	xchg   %ax,%ax
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d60:	8b 0d e8 06 12 80    	mov    0x801206e8,%ecx
80102d66:	85 c9                	test   %ecx,%ecx
80102d68:	0f 8e 8a 00 00 00    	jle    80102df8 <install_trans+0x98>
{
80102d6e:	55                   	push   %ebp
80102d6f:	89 e5                	mov    %esp,%ebp
80102d71:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d72:	31 ff                	xor    %edi,%edi
{
80102d74:	56                   	push   %esi
80102d75:	53                   	push   %ebx
80102d76:	83 ec 0c             	sub    $0xc,%esp
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d80:	a1 d4 06 12 80       	mov    0x801206d4,%eax
80102d85:	83 ec 08             	sub    $0x8,%esp
80102d88:	01 f8                	add    %edi,%eax
80102d8a:	83 c0 01             	add    $0x1,%eax
80102d8d:	50                   	push   %eax
80102d8e:	ff 35 e4 06 12 80    	push   0x801206e4
80102d94:	e8 37 d3 ff ff       	call   801000d0 <bread>
80102d99:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d9b:	58                   	pop    %eax
80102d9c:	5a                   	pop    %edx
80102d9d:	ff 34 bd ec 06 12 80 	push   -0x7fedf914(,%edi,4)
80102da4:	ff 35 e4 06 12 80    	push   0x801206e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102daa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dad:	e8 1e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102db2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102db5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102db7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dba:	68 00 02 00 00       	push   $0x200
80102dbf:	50                   	push   %eax
80102dc0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102dc3:	50                   	push   %eax
80102dc4:	e8 37 1c 00 00       	call   80104a00 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dc9:	89 1c 24             	mov    %ebx,(%esp)
80102dcc:	e8 df d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102dd1:	89 34 24             	mov    %esi,(%esp)
80102dd4:	e8 17 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102dd9:	89 1c 24             	mov    %ebx,(%esp)
80102ddc:	e8 0f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102de1:	83 c4 10             	add    $0x10,%esp
80102de4:	39 3d e8 06 12 80    	cmp    %edi,0x801206e8
80102dea:	7f 94                	jg     80102d80 <install_trans+0x20>
  }
}
80102dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102def:	5b                   	pop    %ebx
80102df0:	5e                   	pop    %esi
80102df1:	5f                   	pop    %edi
80102df2:	5d                   	pop    %ebp
80102df3:	c3                   	ret
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102df8:	c3                   	ret
80102df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e07:	ff 35 d4 06 12 80    	push   0x801206d4
80102e0d:	ff 35 e4 06 12 80    	push   0x801206e4
80102e13:	e8 b8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e18:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e1b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e1d:	a1 e8 06 12 80       	mov    0x801206e8,%eax
80102e22:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e25:	85 c0                	test   %eax,%eax
80102e27:	7e 19                	jle    80102e42 <write_head+0x42>
80102e29:	31 d2                	xor    %edx,%edx
80102e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e30:	8b 0c 95 ec 06 12 80 	mov    -0x7fedf914(,%edx,4),%ecx
80102e37:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e3b:	83 c2 01             	add    $0x1,%edx
80102e3e:	39 d0                	cmp    %edx,%eax
80102e40:	75 ee                	jne    80102e30 <write_head+0x30>
  }
  bwrite(buf);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	53                   	push   %ebx
80102e46:	e8 65 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e4b:	89 1c 24             	mov    %ebx,(%esp)
80102e4e:	e8 9d d3 ff ff       	call   801001f0 <brelse>
}
80102e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e56:	83 c4 10             	add    $0x10,%esp
80102e59:	c9                   	leave
80102e5a:	c3                   	ret
80102e5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102e60 <initlog>:
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 2c             	sub    $0x2c,%esp
80102e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e6a:	68 57 79 10 80       	push   $0x80107957
80102e6f:	68 a0 06 12 80       	push   $0x801206a0
80102e74:	e8 07 18 00 00       	call   80104680 <initlock>
  readsb(dev, &sb);
80102e79:	58                   	pop    %eax
80102e7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e7d:	5a                   	pop    %edx
80102e7e:	50                   	push   %eax
80102e7f:	53                   	push   %ebx
80102e80:	e8 bb e6 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e88:	59                   	pop    %ecx
  log.dev = dev;
80102e89:	89 1d e4 06 12 80    	mov    %ebx,0x801206e4
  log.size = sb.nlog;
80102e8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e92:	a3 d4 06 12 80       	mov    %eax,0x801206d4
  log.size = sb.nlog;
80102e97:	89 15 d8 06 12 80    	mov    %edx,0x801206d8
  struct buf *buf = bread(log.dev, log.start);
80102e9d:	5a                   	pop    %edx
80102e9e:	50                   	push   %eax
80102e9f:	53                   	push   %ebx
80102ea0:	e8 2b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ea5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ea8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102eab:	89 1d e8 06 12 80    	mov    %ebx,0x801206e8
  for (i = 0; i < log.lh.n; i++) {
80102eb1:	85 db                	test   %ebx,%ebx
80102eb3:	7e 1d                	jle    80102ed2 <initlog+0x72>
80102eb5:	31 d2                	xor    %edx,%edx
80102eb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ebe:	00 
80102ebf:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102ec0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ec4:	89 0c 95 ec 06 12 80 	mov    %ecx,-0x7fedf914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ecb:	83 c2 01             	add    $0x1,%edx
80102ece:	39 d3                	cmp    %edx,%ebx
80102ed0:	75 ee                	jne    80102ec0 <initlog+0x60>
  brelse(buf);
80102ed2:	83 ec 0c             	sub    $0xc,%esp
80102ed5:	50                   	push   %eax
80102ed6:	e8 15 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102edb:	e8 80 fe ff ff       	call   80102d60 <install_trans>
  log.lh.n = 0;
80102ee0:	c7 05 e8 06 12 80 00 	movl   $0x0,0x801206e8
80102ee7:	00 00 00 
  write_head(); // clear the log
80102eea:	e8 11 ff ff ff       	call   80102e00 <write_head>
}
80102eef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ef2:	83 c4 10             	add    $0x10,%esp
80102ef5:	c9                   	leave
80102ef6:	c3                   	ret
80102ef7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102efe:	00 
80102eff:	90                   	nop

80102f00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f06:	68 a0 06 12 80       	push   $0x801206a0
80102f0b:	e8 60 19 00 00       	call   80104870 <acquire>
80102f10:	83 c4 10             	add    $0x10,%esp
80102f13:	eb 18                	jmp    80102f2d <begin_op+0x2d>
80102f15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f18:	83 ec 08             	sub    $0x8,%esp
80102f1b:	68 a0 06 12 80       	push   $0x801206a0
80102f20:	68 a0 06 12 80       	push   $0x801206a0
80102f25:	e8 c6 13 00 00       	call   801042f0 <sleep>
80102f2a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f2d:	a1 e0 06 12 80       	mov    0x801206e0,%eax
80102f32:	85 c0                	test   %eax,%eax
80102f34:	75 e2                	jne    80102f18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f36:	a1 dc 06 12 80       	mov    0x801206dc,%eax
80102f3b:	8b 15 e8 06 12 80    	mov    0x801206e8,%edx
80102f41:	83 c0 01             	add    $0x1,%eax
80102f44:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f47:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f4a:	83 fa 1e             	cmp    $0x1e,%edx
80102f4d:	7f c9                	jg     80102f18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f4f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f52:	a3 dc 06 12 80       	mov    %eax,0x801206dc
      release(&log.lock);
80102f57:	68 a0 06 12 80       	push   $0x801206a0
80102f5c:	e8 af 18 00 00       	call   80104810 <release>
      break;
    }
  }
}
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	c9                   	leave
80102f65:	c3                   	ret
80102f66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f6d:	00 
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
80102f75:	53                   	push   %ebx
80102f76:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f79:	68 a0 06 12 80       	push   $0x801206a0
80102f7e:	e8 ed 18 00 00       	call   80104870 <acquire>
  log.outstanding -= 1;
80102f83:	a1 dc 06 12 80       	mov    0x801206dc,%eax
  if(log.committing)
80102f88:	8b 35 e0 06 12 80    	mov    0x801206e0,%esi
80102f8e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f91:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f94:	89 1d dc 06 12 80    	mov    %ebx,0x801206dc
  if(log.committing)
80102f9a:	85 f6                	test   %esi,%esi
80102f9c:	0f 85 22 01 00 00    	jne    801030c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fa2:	85 db                	test   %ebx,%ebx
80102fa4:	0f 85 f6 00 00 00    	jne    801030a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102faa:	c7 05 e0 06 12 80 01 	movl   $0x1,0x801206e0
80102fb1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fb4:	83 ec 0c             	sub    $0xc,%esp
80102fb7:	68 a0 06 12 80       	push   $0x801206a0
80102fbc:	e8 4f 18 00 00       	call   80104810 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fc1:	8b 0d e8 06 12 80    	mov    0x801206e8,%ecx
80102fc7:	83 c4 10             	add    $0x10,%esp
80102fca:	85 c9                	test   %ecx,%ecx
80102fcc:	7f 42                	jg     80103010 <end_op+0xa0>
    acquire(&log.lock);
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 a0 06 12 80       	push   $0x801206a0
80102fd6:	e8 95 18 00 00       	call   80104870 <acquire>
    log.committing = 0;
80102fdb:	c7 05 e0 06 12 80 00 	movl   $0x0,0x801206e0
80102fe2:	00 00 00 
    wakeup(&log);
80102fe5:	c7 04 24 a0 06 12 80 	movl   $0x801206a0,(%esp)
80102fec:	e8 bf 13 00 00       	call   801043b0 <wakeup>
    release(&log.lock);
80102ff1:	c7 04 24 a0 06 12 80 	movl   $0x801206a0,(%esp)
80102ff8:	e8 13 18 00 00       	call   80104810 <release>
80102ffd:	83 c4 10             	add    $0x10,%esp
}
80103000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103003:	5b                   	pop    %ebx
80103004:	5e                   	pop    %esi
80103005:	5f                   	pop    %edi
80103006:	5d                   	pop    %ebp
80103007:	c3                   	ret
80103008:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010300f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103010:	a1 d4 06 12 80       	mov    0x801206d4,%eax
80103015:	83 ec 08             	sub    $0x8,%esp
80103018:	01 d8                	add    %ebx,%eax
8010301a:	83 c0 01             	add    $0x1,%eax
8010301d:	50                   	push   %eax
8010301e:	ff 35 e4 06 12 80    	push   0x801206e4
80103024:	e8 a7 d0 ff ff       	call   801000d0 <bread>
80103029:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010302b:	58                   	pop    %eax
8010302c:	5a                   	pop    %edx
8010302d:	ff 34 9d ec 06 12 80 	push   -0x7fedf914(,%ebx,4)
80103034:	ff 35 e4 06 12 80    	push   0x801206e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010303a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303d:	e8 8e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103042:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103045:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103047:	8d 40 5c             	lea    0x5c(%eax),%eax
8010304a:	68 00 02 00 00       	push   $0x200
8010304f:	50                   	push   %eax
80103050:	8d 46 5c             	lea    0x5c(%esi),%eax
80103053:	50                   	push   %eax
80103054:	e8 a7 19 00 00       	call   80104a00 <memmove>
    bwrite(to);  // write the log
80103059:	89 34 24             	mov    %esi,(%esp)
8010305c:	e8 4f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103061:	89 3c 24             	mov    %edi,(%esp)
80103064:	e8 87 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103069:	89 34 24             	mov    %esi,(%esp)
8010306c:	e8 7f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103071:	83 c4 10             	add    $0x10,%esp
80103074:	3b 1d e8 06 12 80    	cmp    0x801206e8,%ebx
8010307a:	7c 94                	jl     80103010 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010307c:	e8 7f fd ff ff       	call   80102e00 <write_head>
    install_trans(); // Now install writes to home locations
80103081:	e8 da fc ff ff       	call   80102d60 <install_trans>
    log.lh.n = 0;
80103086:	c7 05 e8 06 12 80 00 	movl   $0x0,0x801206e8
8010308d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103090:	e8 6b fd ff ff       	call   80102e00 <write_head>
80103095:	e9 34 ff ff ff       	jmp    80102fce <end_op+0x5e>
8010309a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030a0:	83 ec 0c             	sub    $0xc,%esp
801030a3:	68 a0 06 12 80       	push   $0x801206a0
801030a8:	e8 03 13 00 00       	call   801043b0 <wakeup>
  release(&log.lock);
801030ad:	c7 04 24 a0 06 12 80 	movl   $0x801206a0,(%esp)
801030b4:	e8 57 17 00 00       	call   80104810 <release>
801030b9:	83 c4 10             	add    $0x10,%esp
}
801030bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5f                   	pop    %edi
801030c2:	5d                   	pop    %ebp
801030c3:	c3                   	ret
    panic("log.committing");
801030c4:	83 ec 0c             	sub    $0xc,%esp
801030c7:	68 5b 79 10 80       	push   $0x8010795b
801030cc:	e8 af d2 ff ff       	call   80100380 <panic>
801030d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030d8:	00 
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	53                   	push   %ebx
801030e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030e7:	8b 15 e8 06 12 80    	mov    0x801206e8,%edx
{
801030ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f0:	83 fa 1d             	cmp    $0x1d,%edx
801030f3:	7f 7d                	jg     80103172 <log_write+0x92>
801030f5:	a1 d8 06 12 80       	mov    0x801206d8,%eax
801030fa:	83 e8 01             	sub    $0x1,%eax
801030fd:	39 c2                	cmp    %eax,%edx
801030ff:	7d 71                	jge    80103172 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103101:	a1 dc 06 12 80       	mov    0x801206dc,%eax
80103106:	85 c0                	test   %eax,%eax
80103108:	7e 75                	jle    8010317f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010310a:	83 ec 0c             	sub    $0xc,%esp
8010310d:	68 a0 06 12 80       	push   $0x801206a0
80103112:	e8 59 17 00 00       	call   80104870 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103117:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010311a:	83 c4 10             	add    $0x10,%esp
8010311d:	31 c0                	xor    %eax,%eax
8010311f:	8b 15 e8 06 12 80    	mov    0x801206e8,%edx
80103125:	85 d2                	test   %edx,%edx
80103127:	7f 0e                	jg     80103137 <log_write+0x57>
80103129:	eb 15                	jmp    80103140 <log_write+0x60>
8010312b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103130:	83 c0 01             	add    $0x1,%eax
80103133:	39 c2                	cmp    %eax,%edx
80103135:	74 29                	je     80103160 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103137:	39 0c 85 ec 06 12 80 	cmp    %ecx,-0x7fedf914(,%eax,4)
8010313e:	75 f0                	jne    80103130 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103140:	89 0c 85 ec 06 12 80 	mov    %ecx,-0x7fedf914(,%eax,4)
  if (i == log.lh.n)
80103147:	39 c2                	cmp    %eax,%edx
80103149:	74 1c                	je     80103167 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010314b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010314e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103151:	c7 45 08 a0 06 12 80 	movl   $0x801206a0,0x8(%ebp)
}
80103158:	c9                   	leave
  release(&log.lock);
80103159:	e9 b2 16 00 00       	jmp    80104810 <release>
8010315e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103160:	89 0c 95 ec 06 12 80 	mov    %ecx,-0x7fedf914(,%edx,4)
    log.lh.n++;
80103167:	83 c2 01             	add    $0x1,%edx
8010316a:	89 15 e8 06 12 80    	mov    %edx,0x801206e8
80103170:	eb d9                	jmp    8010314b <log_write+0x6b>
    panic("too big a transaction");
80103172:	83 ec 0c             	sub    $0xc,%esp
80103175:	68 6a 79 10 80       	push   $0x8010796a
8010317a:	e8 01 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010317f:	83 ec 0c             	sub    $0xc,%esp
80103182:	68 80 79 10 80       	push   $0x80107980
80103187:	e8 f4 d1 ff ff       	call   80100380 <panic>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	53                   	push   %ebx
80103194:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103197:	e8 64 09 00 00       	call   80103b00 <cpuid>
8010319c:	89 c3                	mov    %eax,%ebx
8010319e:	e8 5d 09 00 00       	call   80103b00 <cpuid>
801031a3:	83 ec 04             	sub    $0x4,%esp
801031a6:	53                   	push   %ebx
801031a7:	50                   	push   %eax
801031a8:	68 9b 79 10 80       	push   $0x8010799b
801031ad:	e8 fe d4 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801031b2:	e8 59 2a 00 00       	call   80105c10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031b7:	e8 e4 08 00 00       	call   80103aa0 <mycpu>
801031bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031be:	b8 01 00 00 00       	mov    $0x1,%eax
801031c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ca:	e8 11 0d 00 00       	call   80103ee0 <scheduler>
801031cf:	90                   	nop

801031d0 <mpenter>:
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031d6:	e8 f5 3c 00 00       	call   80106ed0 <switchkvm>
  seginit();
801031db:	e8 d0 3b 00 00       	call   80106db0 <seginit>
  lapicinit();
801031e0:	e8 bb f7 ff ff       	call   801029a0 <lapicinit>
  mpmain();
801031e5:	e8 a6 ff ff ff       	call   80103190 <mpmain>
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <main>:
{
801031f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031f4:	83 e4 f0             	and    $0xfffffff0,%esp
801031f7:	ff 71 fc             	push   -0x4(%ecx)
801031fa:	55                   	push   %ebp
801031fb:	89 e5                	mov    %esp,%ebp
801031fd:	53                   	push   %ebx
801031fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031ff:	83 ec 08             	sub    $0x8,%esp
80103202:	68 00 00 40 80       	push   $0x80400000
80103207:	68 d0 44 12 80       	push   $0x801244d0
8010320c:	e8 7f f4 ff ff       	call   80102690 <kinit1>
  kvmalloc();      // kernel page table
80103211:	e8 7a 41 00 00       	call   80107390 <kvmalloc>
  mpinit();        // detect other processors
80103216:	e8 85 01 00 00       	call   801033a0 <mpinit>
  lapicinit();     // interrupt controller
8010321b:	e8 80 f7 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
80103220:	e8 8b 3b 00 00       	call   80106db0 <seginit>
  picinit();       // disable pic
80103225:	e8 86 03 00 00       	call   801035b0 <picinit>
  ioapicinit();    // another interrupt controller
8010322a:	e8 91 f1 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010322f:	e8 2c d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103234:	e8 e7 2d 00 00       	call   80106020 <uartinit>
  pinit();         // process table
80103239:	e8 42 08 00 00       	call   80103a80 <pinit>
  tvinit();        // trap vectors
8010323e:	e8 4d 29 00 00       	call   80105b90 <tvinit>
  binit();         // buffer cache
80103243:	e8 f8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103248:	e8 e3 db ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
8010324d:	e8 4e ef ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103252:	83 c4 0c             	add    $0xc,%esp
80103255:	68 8a 00 00 00       	push   $0x8a
8010325a:	68 8c b4 10 80       	push   $0x8010b48c
8010325f:	68 00 70 00 80       	push   $0x80007000
80103264:	e8 97 17 00 00       	call   80104a00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	69 05 84 07 12 80 b0 	imul   $0xb0,0x80120784,%eax
80103273:	00 00 00 
80103276:	05 a0 07 12 80       	add    $0x801207a0,%eax
8010327b:	3d a0 07 12 80       	cmp    $0x801207a0,%eax
80103280:	76 7e                	jbe    80103300 <main+0x110>
80103282:	bb a0 07 12 80       	mov    $0x801207a0,%ebx
80103287:	eb 20                	jmp    801032a9 <main+0xb9>
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103290:	69 05 84 07 12 80 b0 	imul   $0xb0,0x80120784,%eax
80103297:	00 00 00 
8010329a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032a0:	05 a0 07 12 80       	add    $0x801207a0,%eax
801032a5:	39 c3                	cmp    %eax,%ebx
801032a7:	73 57                	jae    80103300 <main+0x110>
    if(c == mycpu())  // We've started already.
801032a9:	e8 f2 07 00 00       	call   80103aa0 <mycpu>
801032ae:	39 c3                	cmp    %eax,%ebx
801032b0:	74 de                	je     80103290 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032b2:	e8 49 f4 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032b7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801032ba:	c7 05 f8 6f 00 80 d0 	movl   $0x801031d0,0x80006ff8
801032c1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032c4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032cb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ce:	05 00 10 00 00       	add    $0x1000,%eax
801032d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032d8:	0f b6 03             	movzbl (%ebx),%eax
801032db:	68 00 70 00 00       	push   $0x7000
801032e0:	50                   	push   %eax
801032e1:	e8 fa f7 ff ff       	call   80102ae0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032e6:	83 c4 10             	add    $0x10,%esp
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032f6:	85 c0                	test   %eax,%eax
801032f8:	74 f6                	je     801032f0 <main+0x100>
801032fa:	eb 94                	jmp    80103290 <main+0xa0>
801032fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103300:	83 ec 08             	sub    $0x8,%esp
80103303:	68 00 00 00 8e       	push   $0x8e000000
80103308:	68 00 00 40 80       	push   $0x80400000
8010330d:	e8 1e f3 ff ff       	call   80102630 <kinit2>
  userinit();      // first user process
80103312:	e8 39 08 00 00       	call   80103b50 <userinit>
  mpmain();        // finish this processor's setup
80103317:	e8 74 fe ff ff       	call   80103190 <mpmain>
8010331c:	66 90                	xchg   %ax,%ax
8010331e:	66 90                	xchg   %ax,%ax

80103320 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103325:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010332b:	53                   	push   %ebx
  e = addr+len;
8010332c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010332f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103332:	39 de                	cmp    %ebx,%esi
80103334:	72 10                	jb     80103346 <mpsearch1+0x26>
80103336:	eb 50                	jmp    80103388 <mpsearch1+0x68>
80103338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333f:	00 
80103340:	89 fe                	mov    %edi,%esi
80103342:	39 df                	cmp    %ebx,%edi
80103344:	73 42                	jae    80103388 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103346:	83 ec 04             	sub    $0x4,%esp
80103349:	8d 7e 10             	lea    0x10(%esi),%edi
8010334c:	6a 04                	push   $0x4
8010334e:	68 af 79 10 80       	push   $0x801079af
80103353:	56                   	push   %esi
80103354:	e8 57 16 00 00       	call   801049b0 <memcmp>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	85 c0                	test   %eax,%eax
8010335e:	75 e0                	jne    80103340 <mpsearch1+0x20>
80103360:	89 f2                	mov    %esi,%edx
80103362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103368:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010336b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010336e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103370:	39 fa                	cmp    %edi,%edx
80103372:	75 f4                	jne    80103368 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103374:	84 c0                	test   %al,%al
80103376:	75 c8                	jne    80103340 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103378:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010337b:	89 f0                	mov    %esi,%eax
8010337d:	5b                   	pop    %ebx
8010337e:	5e                   	pop    %esi
8010337f:	5f                   	pop    %edi
80103380:	5d                   	pop    %ebp
80103381:	c3                   	ret
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010338b:	31 f6                	xor    %esi,%esi
}
8010338d:	5b                   	pop    %ebx
8010338e:	89 f0                	mov    %esi,%eax
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret
80103394:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010339b:	00 
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033b7:	c1 e0 08             	shl    $0x8,%eax
801033ba:	09 d0                	or     %edx,%eax
801033bc:	c1 e0 04             	shl    $0x4,%eax
801033bf:	75 1b                	jne    801033dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033cf:	c1 e0 08             	shl    $0x8,%eax
801033d2:	09 d0                	or     %edx,%eax
801033d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033dc:	ba 00 04 00 00       	mov    $0x400,%edx
801033e1:	e8 3a ff ff ff       	call   80103320 <mpsearch1>
801033e6:	89 c3                	mov    %eax,%ebx
801033e8:	85 c0                	test   %eax,%eax
801033ea:	0f 84 58 01 00 00    	je     80103548 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033f0:	8b 73 04             	mov    0x4(%ebx),%esi
801033f3:	85 f6                	test   %esi,%esi
801033f5:	0f 84 3d 01 00 00    	je     80103538 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801033fb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033fe:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103404:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103407:	6a 04                	push   $0x4
80103409:	68 b4 79 10 80       	push   $0x801079b4
8010340e:	50                   	push   %eax
8010340f:	e8 9c 15 00 00       	call   801049b0 <memcmp>
80103414:	83 c4 10             	add    $0x10,%esp
80103417:	85 c0                	test   %eax,%eax
80103419:	0f 85 19 01 00 00    	jne    80103538 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010341f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103426:	3c 01                	cmp    $0x1,%al
80103428:	74 08                	je     80103432 <mpinit+0x92>
8010342a:	3c 04                	cmp    $0x4,%al
8010342c:	0f 85 06 01 00 00    	jne    80103538 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103432:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103439:	66 85 d2             	test   %dx,%dx
8010343c:	74 22                	je     80103460 <mpinit+0xc0>
8010343e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103441:	89 f0                	mov    %esi,%eax
  sum = 0;
80103443:	31 d2                	xor    %edx,%edx
80103445:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103448:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010344f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103452:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103454:	39 f8                	cmp    %edi,%eax
80103456:	75 f0                	jne    80103448 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103458:	84 d2                	test   %dl,%dl
8010345a:	0f 85 d8 00 00 00    	jne    80103538 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103460:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103469:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010346c:	a3 80 06 12 80       	mov    %eax,0x80120680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103471:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103478:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010347e:	01 d7                	add    %edx,%edi
80103480:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103482:	bf 01 00 00 00       	mov    $0x1,%edi
80103487:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010348e:	00 
8010348f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103490:	39 d0                	cmp    %edx,%eax
80103492:	73 19                	jae    801034ad <mpinit+0x10d>
    switch(*p){
80103494:	0f b6 08             	movzbl (%eax),%ecx
80103497:	80 f9 02             	cmp    $0x2,%cl
8010349a:	0f 84 80 00 00 00    	je     80103520 <mpinit+0x180>
801034a0:	77 6e                	ja     80103510 <mpinit+0x170>
801034a2:	84 c9                	test   %cl,%cl
801034a4:	74 3a                	je     801034e0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034a6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a9:	39 d0                	cmp    %edx,%eax
801034ab:	72 e7                	jb     80103494 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034b0:	85 ff                	test   %edi,%edi
801034b2:	0f 84 dd 00 00 00    	je     80103595 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034b8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034bc:	74 15                	je     801034d3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034be:	b8 70 00 00 00       	mov    $0x70,%eax
801034c3:	ba 22 00 00 00       	mov    $0x22,%edx
801034c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034c9:	ba 23 00 00 00       	mov    $0x23,%edx
801034ce:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034cf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d2:	ee                   	out    %al,(%dx)
  }
}
801034d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d6:	5b                   	pop    %ebx
801034d7:	5e                   	pop    %esi
801034d8:	5f                   	pop    %edi
801034d9:	5d                   	pop    %ebp
801034da:	c3                   	ret
801034db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801034e0:	8b 0d 84 07 12 80    	mov    0x80120784,%ecx
801034e6:	83 f9 07             	cmp    $0x7,%ecx
801034e9:	7f 19                	jg     80103504 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034eb:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801034f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034f5:	83 c1 01             	add    $0x1,%ecx
801034f8:	89 0d 84 07 12 80    	mov    %ecx,0x80120784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034fe:	88 9e a0 07 12 80    	mov    %bl,-0x7fedf860(%esi)
      p += sizeof(struct mpproc);
80103504:	83 c0 14             	add    $0x14,%eax
      continue;
80103507:	eb 87                	jmp    80103490 <mpinit+0xf0>
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103510:	83 e9 03             	sub    $0x3,%ecx
80103513:	80 f9 01             	cmp    $0x1,%cl
80103516:	76 8e                	jbe    801034a6 <mpinit+0x106>
80103518:	31 ff                	xor    %edi,%edi
8010351a:	e9 71 ff ff ff       	jmp    80103490 <mpinit+0xf0>
8010351f:	90                   	nop
      ioapicid = ioapic->apicno;
80103520:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103524:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103527:	88 0d 80 07 12 80    	mov    %cl,0x80120780
      continue;
8010352d:	e9 5e ff ff ff       	jmp    80103490 <mpinit+0xf0>
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103538:	83 ec 0c             	sub    $0xc,%esp
8010353b:	68 b9 79 10 80       	push   $0x801079b9
80103540:	e8 3b ce ff ff       	call   80100380 <panic>
80103545:	8d 76 00             	lea    0x0(%esi),%esi
{
80103548:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010354d:	eb 0b                	jmp    8010355a <mpinit+0x1ba>
8010354f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103550:	89 f3                	mov    %esi,%ebx
80103552:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103558:	74 de                	je     80103538 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010355a:	83 ec 04             	sub    $0x4,%esp
8010355d:	8d 73 10             	lea    0x10(%ebx),%esi
80103560:	6a 04                	push   $0x4
80103562:	68 af 79 10 80       	push   $0x801079af
80103567:	53                   	push   %ebx
80103568:	e8 43 14 00 00       	call   801049b0 <memcmp>
8010356d:	83 c4 10             	add    $0x10,%esp
80103570:	85 c0                	test   %eax,%eax
80103572:	75 dc                	jne    80103550 <mpinit+0x1b0>
80103574:	89 da                	mov    %ebx,%edx
80103576:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010357d:	00 
8010357e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103580:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103583:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103586:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103588:	39 d6                	cmp    %edx,%esi
8010358a:	75 f4                	jne    80103580 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010358c:	84 c0                	test   %al,%al
8010358e:	75 c0                	jne    80103550 <mpinit+0x1b0>
80103590:	e9 5b fe ff ff       	jmp    801033f0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103595:	83 ec 0c             	sub    $0xc,%esp
80103598:	68 80 7d 10 80       	push   $0x80107d80
8010359d:	e8 de cd ff ff       	call   80100380 <panic>
801035a2:	66 90                	xchg   %ax,%ax
801035a4:	66 90                	xchg   %ax,%ax
801035a6:	66 90                	xchg   %ax,%ax
801035a8:	66 90                	xchg   %ax,%ax
801035aa:	66 90                	xchg   %ax,%ax
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <picinit>:
801035b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035b5:	ba 21 00 00 00       	mov    $0x21,%edx
801035ba:	ee                   	out    %al,(%dx)
801035bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801035c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035c1:	c3                   	ret
801035c2:	66 90                	xchg   %ax,%ax
801035c4:	66 90                	xchg   %ax,%ax
801035c6:	66 90                	xchg   %ax,%ax
801035c8:	66 90                	xchg   %ax,%ax
801035ca:	66 90                	xchg   %ax,%ax
801035cc:	66 90                	xchg   %ax,%ax
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 0c             	sub    $0xc,%esp
801035d9:	8b 75 08             	mov    0x8(%ebp),%esi
801035dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801035e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035eb:	e8 60 d8 ff ff       	call   80100e50 <filealloc>
801035f0:	89 06                	mov    %eax,(%esi)
801035f2:	85 c0                	test   %eax,%eax
801035f4:	0f 84 a5 00 00 00    	je     8010369f <pipealloc+0xcf>
801035fa:	e8 51 d8 ff ff       	call   80100e50 <filealloc>
801035ff:	89 07                	mov    %eax,(%edi)
80103601:	85 c0                	test   %eax,%eax
80103603:	0f 84 84 00 00 00    	je     8010368d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103609:	e8 f2 f0 ff ff       	call   80102700 <kalloc>
8010360e:	89 c3                	mov    %eax,%ebx
80103610:	85 c0                	test   %eax,%eax
80103612:	0f 84 a0 00 00 00    	je     801036b8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103618:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010361f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103622:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103625:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010362c:	00 00 00 
  p->nwrite = 0;
8010362f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103636:	00 00 00 
  p->nread = 0;
80103639:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103640:	00 00 00 
  initlock(&p->lock, "pipe");
80103643:	68 d1 79 10 80       	push   $0x801079d1
80103648:	50                   	push   %eax
80103649:	e8 32 10 00 00       	call   80104680 <initlock>
  (*f0)->type = FD_PIPE;
8010364e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103650:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103653:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103659:	8b 06                	mov    (%esi),%eax
8010365b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010365f:	8b 06                	mov    (%esi),%eax
80103661:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103665:	8b 06                	mov    (%esi),%eax
80103667:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010366a:	8b 07                	mov    (%edi),%eax
8010366c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103672:	8b 07                	mov    (%edi),%eax
80103674:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103678:	8b 07                	mov    (%edi),%eax
8010367a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010367e:	8b 07                	mov    (%edi),%eax
80103680:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103683:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103688:	5b                   	pop    %ebx
80103689:	5e                   	pop    %esi
8010368a:	5f                   	pop    %edi
8010368b:	5d                   	pop    %ebp
8010368c:	c3                   	ret
  if(*f0)
8010368d:	8b 06                	mov    (%esi),%eax
8010368f:	85 c0                	test   %eax,%eax
80103691:	74 1e                	je     801036b1 <pipealloc+0xe1>
    fileclose(*f0);
80103693:	83 ec 0c             	sub    $0xc,%esp
80103696:	50                   	push   %eax
80103697:	e8 74 d8 ff ff       	call   80100f10 <fileclose>
8010369c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010369f:	8b 07                	mov    (%edi),%eax
801036a1:	85 c0                	test   %eax,%eax
801036a3:	74 0c                	je     801036b1 <pipealloc+0xe1>
    fileclose(*f1);
801036a5:	83 ec 0c             	sub    $0xc,%esp
801036a8:	50                   	push   %eax
801036a9:	e8 62 d8 ff ff       	call   80100f10 <fileclose>
801036ae:	83 c4 10             	add    $0x10,%esp
  return -1;
801036b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036b6:	eb cd                	jmp    80103685 <pipealloc+0xb5>
  if(*f0)
801036b8:	8b 06                	mov    (%esi),%eax
801036ba:	85 c0                	test   %eax,%eax
801036bc:	75 d5                	jne    80103693 <pipealloc+0xc3>
801036be:	eb df                	jmp    8010369f <pipealloc+0xcf>

801036c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	53                   	push   %ebx
801036cf:	e8 9c 11 00 00       	call   80104870 <acquire>
  if(writable){
801036d4:	83 c4 10             	add    $0x10,%esp
801036d7:	85 f6                	test   %esi,%esi
801036d9:	74 65                	je     80103740 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036db:	83 ec 0c             	sub    $0xc,%esp
801036de:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036eb:	00 00 00 
    wakeup(&p->nread);
801036ee:	50                   	push   %eax
801036ef:	e8 bc 0c 00 00       	call   801043b0 <wakeup>
801036f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036fd:	85 d2                	test   %edx,%edx
801036ff:	75 0a                	jne    8010370b <pipeclose+0x4b>
80103701:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103707:	85 c0                	test   %eax,%eax
80103709:	74 15                	je     80103720 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010370b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010370e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103711:	5b                   	pop    %ebx
80103712:	5e                   	pop    %esi
80103713:	5d                   	pop    %ebp
    release(&p->lock);
80103714:	e9 f7 10 00 00       	jmp    80104810 <release>
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	53                   	push   %ebx
80103724:	e8 e7 10 00 00       	call   80104810 <release>
    kfree((char*)p);
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010372f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103732:	5b                   	pop    %ebx
80103733:	5e                   	pop    %esi
80103734:	5d                   	pop    %ebp
    kfree((char*)p);
80103735:	e9 66 ed ff ff       	jmp    801024a0 <kfree>
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103749:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103750:	00 00 00 
    wakeup(&p->nwrite);
80103753:	50                   	push   %eax
80103754:	e8 57 0c 00 00       	call   801043b0 <wakeup>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	eb 99                	jmp    801036f7 <pipeclose+0x37>
8010375e:	66 90                	xchg   %ax,%ax

80103760 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	57                   	push   %edi
80103764:	56                   	push   %esi
80103765:	53                   	push   %ebx
80103766:	83 ec 28             	sub    $0x28,%esp
80103769:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010376c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010376f:	53                   	push   %ebx
80103770:	e8 fb 10 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++){
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 ff                	test   %edi,%edi
8010377a:	0f 8e ce 00 00 00    	jle    8010384e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103780:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103786:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103789:	89 7d 10             	mov    %edi,0x10(%ebp)
8010378c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010378f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103792:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103795:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010379b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037a1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801037ad:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801037b0:	0f 85 b6 00 00 00    	jne    8010386c <pipewrite+0x10c>
801037b6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037b9:	eb 3b                	jmp    801037f6 <pipewrite+0x96>
801037bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801037c0:	e8 5b 03 00 00       	call   80103b20 <myproc>
801037c5:	8b 48 24             	mov    0x24(%eax),%ecx
801037c8:	85 c9                	test   %ecx,%ecx
801037ca:	75 34                	jne    80103800 <pipewrite+0xa0>
      wakeup(&p->nread);
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	56                   	push   %esi
801037d0:	e8 db 0b 00 00       	call   801043b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d5:	58                   	pop    %eax
801037d6:	5a                   	pop    %edx
801037d7:	53                   	push   %ebx
801037d8:	57                   	push   %edi
801037d9:	e8 12 0b 00 00       	call   801042f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037de:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037e4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037ea:	83 c4 10             	add    $0x10,%esp
801037ed:	05 00 02 00 00       	add    $0x200,%eax
801037f2:	39 c2                	cmp    %eax,%edx
801037f4:	75 2a                	jne    80103820 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037f6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037fc:	85 c0                	test   %eax,%eax
801037fe:	75 c0                	jne    801037c0 <pipewrite+0x60>
        release(&p->lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
80103803:	53                   	push   %ebx
80103804:	e8 07 10 00 00       	call   80104810 <release>
        return -1;
80103809:	83 c4 10             	add    $0x10,%esp
8010380c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103814:	5b                   	pop    %ebx
80103815:	5e                   	pop    %esi
80103816:	5f                   	pop    %edi
80103817:	5d                   	pop    %ebp
80103818:	c3                   	ret
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103820:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103823:	8d 42 01             	lea    0x1(%edx),%eax
80103826:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010382c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010382f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103838:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010383c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103840:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103843:	39 c1                	cmp    %eax,%ecx
80103845:	0f 85 50 ff ff ff    	jne    8010379b <pipewrite+0x3b>
8010384b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010384e:	83 ec 0c             	sub    $0xc,%esp
80103851:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103857:	50                   	push   %eax
80103858:	e8 53 0b 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
8010385d:	89 1c 24             	mov    %ebx,(%esp)
80103860:	e8 ab 0f 00 00       	call   80104810 <release>
  return n;
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	89 f8                	mov    %edi,%eax
8010386a:	eb a5                	jmp    80103811 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010386c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010386f:	eb b2                	jmp    80103823 <pipewrite+0xc3>
80103871:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103878:	00 
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 18             	sub    $0x18,%esp
80103889:	8b 75 08             	mov    0x8(%ebp),%esi
8010388c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010388f:	56                   	push   %esi
80103890:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103896:	e8 d5 0f 00 00       	call   80104870 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010389b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038a1:	83 c4 10             	add    $0x10,%esp
801038a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038aa:	74 2f                	je     801038db <piperead+0x5b>
801038ac:	eb 37                	jmp    801038e5 <piperead+0x65>
801038ae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038b0:	e8 6b 02 00 00       	call   80103b20 <myproc>
801038b5:	8b 40 24             	mov    0x24(%eax),%eax
801038b8:	85 c0                	test   %eax,%eax
801038ba:	0f 85 80 00 00 00    	jne    80103940 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038c0:	83 ec 08             	sub    $0x8,%esp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
801038c5:	e8 26 0a 00 00       	call   801042f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ca:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038d9:	75 0a                	jne    801038e5 <piperead+0x65>
801038db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801038e1:	85 d2                	test   %edx,%edx
801038e3:	75 cb                	jne    801038b0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801038e8:	31 db                	xor    %ebx,%ebx
801038ea:	85 c9                	test   %ecx,%ecx
801038ec:	7f 26                	jg     80103914 <piperead+0x94>
801038ee:	eb 2c                	jmp    8010391c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038f0:	8d 48 01             	lea    0x1(%eax),%ecx
801038f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103903:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103906:	83 c3 01             	add    $0x1,%ebx
80103909:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010390c:	74 0e                	je     8010391c <piperead+0x9c>
8010390e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103914:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010391a:	75 d4                	jne    801038f0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010391c:	83 ec 0c             	sub    $0xc,%esp
8010391f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103925:	50                   	push   %eax
80103926:	e8 85 0a 00 00       	call   801043b0 <wakeup>
  release(&p->lock);
8010392b:	89 34 24             	mov    %esi,(%esp)
8010392e:	e8 dd 0e 00 00       	call   80104810 <release>
  return i;
80103933:	83 c4 10             	add    $0x10,%esp
}
80103936:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103939:	89 d8                	mov    %ebx,%eax
8010393b:	5b                   	pop    %ebx
8010393c:	5e                   	pop    %esi
8010393d:	5f                   	pop    %edi
8010393e:	5d                   	pop    %ebp
8010393f:	c3                   	ret
      release(&p->lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103943:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103948:	56                   	push   %esi
80103949:	e8 c2 0e 00 00       	call   80104810 <release>
      return -1;
8010394e:	83 c4 10             	add    $0x10,%esp
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103954:	89 d8                	mov    %ebx,%eax
80103956:	5b                   	pop    %ebx
80103957:	5e                   	pop    %esi
80103958:	5f                   	pop    %edi
80103959:	5d                   	pop    %ebp
8010395a:	c3                   	ret
8010395b:	66 90                	xchg   %ax,%ax
8010395d:	66 90                	xchg   %ax,%ax
8010395f:	90                   	nop

80103960 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103964:	bb 54 0d 12 80       	mov    $0x80120d54,%ebx
{
80103969:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010396c:	68 20 0d 12 80       	push   $0x80120d20
80103971:	e8 fa 0e 00 00       	call   80104870 <acquire>
80103976:	83 c4 10             	add    $0x10,%esp
80103979:	eb 10                	jmp    8010398b <allocproc+0x2b>
8010397b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103980:	83 c3 7c             	add    $0x7c,%ebx
80103983:	81 fb 54 2c 12 80    	cmp    $0x80122c54,%ebx
80103989:	74 75                	je     80103a00 <allocproc+0xa0>
    if(p->state == UNUSED)
8010398b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010398e:	85 c0                	test   %eax,%eax
80103990:	75 ee                	jne    80103980 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103992:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103997:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010399a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039a1:	89 43 10             	mov    %eax,0x10(%ebx)
801039a4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039a7:	68 20 0d 12 80       	push   $0x80120d20
  p->pid = nextpid++;
801039ac:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039b2:	e8 59 0e 00 00       	call   80104810 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039b7:	e8 44 ed ff ff       	call   80102700 <kalloc>
801039bc:	83 c4 10             	add    $0x10,%esp
801039bf:	89 43 08             	mov    %eax,0x8(%ebx)
801039c2:	85 c0                	test   %eax,%eax
801039c4:	74 53                	je     80103a19 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039c6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039cc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039cf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039d4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801039d7:	c7 40 14 7d 5b 10 80 	movl   $0x80105b7d,0x14(%eax)
  p->context = (struct context*)sp;
801039de:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039e1:	6a 14                	push   $0x14
801039e3:	6a 00                	push   $0x0
801039e5:	50                   	push   %eax
801039e6:	e8 85 0f 00 00       	call   80104970 <memset>
  p->context->eip = (uint)forkret;
801039eb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039ee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039f1:	c7 40 10 30 3a 10 80 	movl   $0x80103a30,0x10(%eax)
}
801039f8:	89 d8                	mov    %ebx,%eax
801039fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039fd:	c9                   	leave
801039fe:	c3                   	ret
801039ff:	90                   	nop
  release(&ptable.lock);
80103a00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a05:	68 20 0d 12 80       	push   $0x80120d20
80103a0a:	e8 01 0e 00 00       	call   80104810 <release>
  return 0;
80103a0f:	83 c4 10             	add    $0x10,%esp
}
80103a12:	89 d8                	mov    %ebx,%eax
80103a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a17:	c9                   	leave
80103a18:	c3                   	ret
    p->state = UNUSED;
80103a19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103a20:	31 db                	xor    %ebx,%ebx
80103a22:	eb ee                	jmp    80103a12 <allocproc+0xb2>
80103a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a2b:	00 
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a36:	68 20 0d 12 80       	push   $0x80120d20
80103a3b:	e8 d0 0d 00 00       	call   80104810 <release>

  if (first) {
80103a40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	85 c0                	test   %eax,%eax
80103a4a:	75 04                	jne    80103a50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a4c:	c9                   	leave
80103a4d:	c3                   	ret
80103a4e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a50:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a57:	00 00 00 
    iinit(ROOTDEV);
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	6a 01                	push   $0x1
80103a5f:	e8 1c db ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
80103a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a6b:	e8 f0 f3 ff ff       	call   80102e60 <initlog>
}
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	c9                   	leave
80103a74:	c3                   	ret
80103a75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a7c:	00 
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi

80103a80 <pinit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a86:	68 d6 79 10 80       	push   $0x801079d6
80103a8b:	68 20 0d 12 80       	push   $0x80120d20
80103a90:	e8 eb 0b 00 00       	call   80104680 <initlock>
}
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	c9                   	leave
80103a99:	c3                   	ret
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103aa0 <mycpu>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aa5:	9c                   	pushf
80103aa6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aa7:	f6 c4 02             	test   $0x2,%ah
80103aaa:	75 46                	jne    80103af2 <mycpu+0x52>
  apicid = lapicid();
80103aac:	e8 df ef ff ff       	call   80102a90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ab1:	8b 35 84 07 12 80    	mov    0x80120784,%esi
80103ab7:	85 f6                	test   %esi,%esi
80103ab9:	7e 2a                	jle    80103ae5 <mycpu+0x45>
80103abb:	31 d2                	xor    %edx,%edx
80103abd:	eb 08                	jmp    80103ac7 <mycpu+0x27>
80103abf:	90                   	nop
80103ac0:	83 c2 01             	add    $0x1,%edx
80103ac3:	39 f2                	cmp    %esi,%edx
80103ac5:	74 1e                	je     80103ae5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ac7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103acd:	0f b6 99 a0 07 12 80 	movzbl -0x7fedf860(%ecx),%ebx
80103ad4:	39 c3                	cmp    %eax,%ebx
80103ad6:	75 e8                	jne    80103ac0 <mycpu+0x20>
}
80103ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103adb:	8d 81 a0 07 12 80    	lea    -0x7fedf860(%ecx),%eax
}
80103ae1:	5b                   	pop    %ebx
80103ae2:	5e                   	pop    %esi
80103ae3:	5d                   	pop    %ebp
80103ae4:	c3                   	ret
  panic("unknown apicid\n");
80103ae5:	83 ec 0c             	sub    $0xc,%esp
80103ae8:	68 dd 79 10 80       	push   $0x801079dd
80103aed:	e8 8e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103af2:	83 ec 0c             	sub    $0xc,%esp
80103af5:	68 a0 7d 10 80       	push   $0x80107da0
80103afa:	e8 81 c8 ff ff       	call   80100380 <panic>
80103aff:	90                   	nop

80103b00 <cpuid>:
cpuid() {
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b06:	e8 95 ff ff ff       	call   80103aa0 <mycpu>
}
80103b0b:	c9                   	leave
  return mycpu()-cpus;
80103b0c:	2d a0 07 12 80       	sub    $0x801207a0,%eax
80103b11:	c1 f8 04             	sar    $0x4,%eax
80103b14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b1a:	c3                   	ret
80103b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b20 <myproc>:
myproc(void) {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b27:	e8 f4 0b 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103b2c:	e8 6f ff ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103b31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b37:	e8 34 0c 00 00       	call   80104770 <popcli>
}
80103b3c:	89 d8                	mov    %ebx,%eax
80103b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b41:	c9                   	leave
80103b42:	c3                   	ret
80103b43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b4a:	00 
80103b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b50 <userinit>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b57:	e8 04 fe ff ff       	call   80103960 <allocproc>
80103b5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b5e:	a3 54 2c 12 80       	mov    %eax,0x80122c54
  if((p->pgdir = setupkvm()) == 0)
80103b63:	e8 a8 37 00 00       	call   80107310 <setupkvm>
80103b68:	89 43 04             	mov    %eax,0x4(%ebx)
80103b6b:	85 c0                	test   %eax,%eax
80103b6d:	0f 84 bd 00 00 00    	je     80103c30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b73:	83 ec 04             	sub    $0x4,%esp
80103b76:	68 2c 00 00 00       	push   $0x2c
80103b7b:	68 60 b4 10 80       	push   $0x8010b460
80103b80:	50                   	push   %eax
80103b81:	e8 6a 34 00 00       	call   80106ff0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b8f:	6a 4c                	push   $0x4c
80103b91:	6a 00                	push   $0x0
80103b93:	ff 73 18             	push   0x18(%ebx)
80103b96:	e8 d5 0d 00 00       	call   80104970 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ba3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ba6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103baf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bcc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103be0:	8b 43 18             	mov    0x18(%ebx),%eax
80103be3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	68 06 7a 10 80       	push   $0x80107a06
80103bf4:	50                   	push   %eax
80103bf5:	e8 26 0f 00 00       	call   80104b20 <safestrcpy>
  p->cwd = namei("/");
80103bfa:	c7 04 24 0f 7a 10 80 	movl   $0x80107a0f,(%esp)
80103c01:	e8 7a e4 ff ff       	call   80102080 <namei>
80103c06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c09:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
80103c10:	e8 5b 0c 00 00       	call   80104870 <acquire>
  p->state = RUNNABLE;
80103c15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c1c:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
80103c23:	e8 e8 0b 00 00       	call   80104810 <release>
}
80103c28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c2b:	83 c4 10             	add    $0x10,%esp
80103c2e:	c9                   	leave
80103c2f:	c3                   	ret
    panic("userinit: out of memory?");
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	68 ed 79 10 80       	push   $0x801079ed
80103c38:	e8 43 c7 ff ff       	call   80100380 <panic>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi

80103c40 <growproc>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
80103c45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c48:	e8 d3 0a 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103c4d:	e8 4e fe ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103c52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c58:	e8 13 0b 00 00       	call   80104770 <popcli>
  sz = curproc->sz;
80103c5d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c5f:	85 f6                	test   %esi,%esi
80103c61:	7f 1d                	jg     80103c80 <growproc+0x40>
  } else if(n < 0){
80103c63:	75 3b                	jne    80103ca0 <growproc+0x60>
  switchuvm(curproc);
80103c65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c6a:	53                   	push   %ebx
80103c6b:	e8 70 32 00 00       	call   80106ee0 <switchuvm>
  return 0;
80103c70:	83 c4 10             	add    $0x10,%esp
80103c73:	31 c0                	xor    %eax,%eax
}
80103c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c78:	5b                   	pop    %ebx
80103c79:	5e                   	pop    %esi
80103c7a:	5d                   	pop    %ebp
80103c7b:	c3                   	ret
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c80:	83 ec 04             	sub    $0x4,%esp
80103c83:	01 c6                	add    %eax,%esi
80103c85:	56                   	push   %esi
80103c86:	50                   	push   %eax
80103c87:	ff 73 04             	push   0x4(%ebx)
80103c8a:	e8 b1 34 00 00       	call   80107140 <allocuvm>
80103c8f:	83 c4 10             	add    $0x10,%esp
80103c92:	85 c0                	test   %eax,%eax
80103c94:	75 cf                	jne    80103c65 <growproc+0x25>
      return -1;
80103c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c9b:	eb d8                	jmp    80103c75 <growproc+0x35>
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca0:	83 ec 04             	sub    $0x4,%esp
80103ca3:	01 c6                	add    %eax,%esi
80103ca5:	56                   	push   %esi
80103ca6:	50                   	push   %eax
80103ca7:	ff 73 04             	push   0x4(%ebx)
80103caa:	e8 b1 35 00 00       	call   80107260 <deallocuvm>
80103caf:	83 c4 10             	add    $0x10,%esp
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	75 af                	jne    80103c65 <growproc+0x25>
80103cb6:	eb de                	jmp    80103c96 <growproc+0x56>
80103cb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cbf:	00 

80103cc0 <fork>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cc9:	e8 52 0a 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103cce:	e8 cd fd ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103cd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd9:	e8 92 0a 00 00       	call   80104770 <popcli>
  if((np = allocproc()) == 0){
80103cde:	e8 7d fc ff ff       	call   80103960 <allocproc>
80103ce3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ce6:	85 c0                	test   %eax,%eax
80103ce8:	0f 84 d6 00 00 00    	je     80103dc4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cee:	83 ec 08             	sub    $0x8,%esp
80103cf1:	ff 33                	push   (%ebx)
80103cf3:	89 c7                	mov    %eax,%edi
80103cf5:	ff 73 04             	push   0x4(%ebx)
80103cf8:	e8 03 37 00 00       	call   80107400 <copyuvm>
80103cfd:	83 c4 10             	add    $0x10,%esp
80103d00:	89 47 04             	mov    %eax,0x4(%edi)
80103d03:	85 c0                	test   %eax,%eax
80103d05:	0f 84 9a 00 00 00    	je     80103da5 <fork+0xe5>
  np->sz = curproc->sz;
80103d0b:	8b 03                	mov    (%ebx),%eax
80103d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d10:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d12:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d15:	89 c8                	mov    %ecx,%eax
80103d17:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d1a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d1f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d26:	8b 40 18             	mov    0x18(%eax),%eax
80103d29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d34:	85 c0                	test   %eax,%eax
80103d36:	74 13                	je     80103d4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d38:	83 ec 0c             	sub    $0xc,%esp
80103d3b:	50                   	push   %eax
80103d3c:	e8 7f d1 ff ff       	call   80100ec0 <filedup>
80103d41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d44:	83 c4 10             	add    $0x10,%esp
80103d47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d4b:	83 c6 01             	add    $0x1,%esi
80103d4e:	83 fe 10             	cmp    $0x10,%esi
80103d51:	75 dd                	jne    80103d30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d53:	83 ec 0c             	sub    $0xc,%esp
80103d56:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d5c:	e8 0f da ff ff       	call   80101770 <idup>
80103d61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d6d:	6a 10                	push   $0x10
80103d6f:	53                   	push   %ebx
80103d70:	50                   	push   %eax
80103d71:	e8 aa 0d 00 00       	call   80104b20 <safestrcpy>
  pid = np->pid;
80103d76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d79:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
80103d80:	e8 eb 0a 00 00       	call   80104870 <acquire>
  np->state = RUNNABLE;
80103d85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d8c:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
80103d93:	e8 78 0a 00 00       	call   80104810 <release>
  return pid;
80103d98:	83 c4 10             	add    $0x10,%esp
}
80103d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d9e:	89 d8                	mov    %ebx,%eax
80103da0:	5b                   	pop    %ebx
80103da1:	5e                   	pop    %esi
80103da2:	5f                   	pop    %edi
80103da3:	5d                   	pop    %ebp
80103da4:	c3                   	ret
    kfree(np->kstack);
80103da5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103da8:	83 ec 0c             	sub    $0xc,%esp
80103dab:	ff 73 08             	push   0x8(%ebx)
80103dae:	e8 ed e6 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103db3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103dba:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103dbd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103dc4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dc9:	eb d0                	jmp    80103d9b <fork+0xdb>
80103dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103dd0 <cowfork>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103dd9:	e8 42 09 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103dde:	e8 bd fc ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103de3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de9:	e8 82 09 00 00       	call   80104770 <popcli>
  if((np = allocproc()) == 0){
80103dee:	e8 6d fb ff ff       	call   80103960 <allocproc>
80103df3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103df6:	85 c0                	test   %eax,%eax
80103df8:	0f 84 d6 00 00 00    	je     80103ed4 <cowfork+0x104>
  if((np->pgdir = copyuvm_cow(curproc->pgdir, curproc->sz)) == 0){
80103dfe:	83 ec 08             	sub    $0x8,%esp
80103e01:	ff 33                	push   (%ebx)
80103e03:	89 c7                	mov    %eax,%edi
80103e05:	ff 73 04             	push   0x4(%ebx)
80103e08:	e8 23 37 00 00       	call   80107530 <copyuvm_cow>
80103e0d:	83 c4 10             	add    $0x10,%esp
80103e10:	89 47 04             	mov    %eax,0x4(%edi)
80103e13:	85 c0                	test   %eax,%eax
80103e15:	0f 84 9a 00 00 00    	je     80103eb5 <cowfork+0xe5>
  np->sz = curproc->sz;
80103e1b:	8b 03                	mov    (%ebx),%eax
80103e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e25:	89 c8                	mov    %ecx,%eax
80103e27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e2f:	8b 73 18             	mov    0x18(%ebx),%esi
80103e32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e36:	8b 40 18             	mov    0x18(%eax),%eax
80103e39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e44:	85 c0                	test   %eax,%eax
80103e46:	74 13                	je     80103e5b <cowfork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	50                   	push   %eax
80103e4c:	e8 6f d0 ff ff       	call   80100ec0 <filedup>
80103e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e54:	83 c4 10             	add    $0x10,%esp
80103e57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e5b:	83 c6 01             	add    $0x1,%esi
80103e5e:	83 fe 10             	cmp    $0x10,%esi
80103e61:	75 dd                	jne    80103e40 <cowfork+0x70>
  np->cwd = idup(curproc->cwd);
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e6c:	e8 ff d8 ff ff       	call   80101770 <idup>
80103e71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e7d:	6a 10                	push   $0x10
80103e7f:	53                   	push   %ebx
80103e80:	50                   	push   %eax
80103e81:	e8 9a 0c 00 00       	call   80104b20 <safestrcpy>
  pid = np->pid;
80103e86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e89:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
80103e90:	e8 db 09 00 00       	call   80104870 <acquire>
  np->state = RUNNABLE;
80103e95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e9c:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
80103ea3:	e8 68 09 00 00       	call   80104810 <release>
  return pid;
80103ea8:	83 c4 10             	add    $0x10,%esp
}
80103eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eae:	89 d8                	mov    %ebx,%eax
80103eb0:	5b                   	pop    %ebx
80103eb1:	5e                   	pop    %esi
80103eb2:	5f                   	pop    %edi
80103eb3:	5d                   	pop    %ebp
80103eb4:	c3                   	ret
    kfree(np->kstack);
80103eb5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	ff 73 08             	push   0x8(%ebx)
80103ebe:	e8 dd e5 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103ec3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103eca:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ecd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ed4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ed9:	eb d0                	jmp    80103eab <cowfork+0xdb>
80103edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ee0 <scheduler>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ee9:	e8 b2 fb ff ff       	call   80103aa0 <mycpu>
  c->proc = 0;
80103eee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ef5:	00 00 00 
  struct cpu *c = mycpu();
80103ef8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103efa:	8d 78 04             	lea    0x4(%eax),%edi
80103efd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f00:	fb                   	sti
    acquire(&ptable.lock);
80103f01:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f04:	bb 54 0d 12 80       	mov    $0x80120d54,%ebx
    acquire(&ptable.lock);
80103f09:	68 20 0d 12 80       	push   $0x80120d20
80103f0e:	e8 5d 09 00 00       	call   80104870 <acquire>
80103f13:	83 c4 10             	add    $0x10,%esp
80103f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f1d:	00 
80103f1e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103f20:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f24:	75 33                	jne    80103f59 <scheduler+0x79>
      switchuvm(p);
80103f26:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f2f:	53                   	push   %ebx
80103f30:	e8 ab 2f 00 00       	call   80106ee0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f35:	58                   	pop    %eax
80103f36:	5a                   	pop    %edx
80103f37:	ff 73 1c             	push   0x1c(%ebx)
80103f3a:	57                   	push   %edi
      p->state = RUNNING;
80103f3b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f42:	e8 34 0c 00 00       	call   80104b7b <swtch>
      switchkvm();
80103f47:	e8 84 2f 00 00       	call   80106ed0 <switchkvm>
      c->proc = 0;
80103f4c:	83 c4 10             	add    $0x10,%esp
80103f4f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f56:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f59:	83 c3 7c             	add    $0x7c,%ebx
80103f5c:	81 fb 54 2c 12 80    	cmp    $0x80122c54,%ebx
80103f62:	75 bc                	jne    80103f20 <scheduler+0x40>
    release(&ptable.lock);
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 20 0d 12 80       	push   $0x80120d20
80103f6c:	e8 9f 08 00 00       	call   80104810 <release>
    sti();
80103f71:	83 c4 10             	add    $0x10,%esp
80103f74:	eb 8a                	jmp    80103f00 <scheduler+0x20>
80103f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f7d:	00 
80103f7e:	66 90                	xchg   %ax,%ax

80103f80 <sched>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
  pushcli();
80103f85:	e8 96 07 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103f8a:	e8 11 fb ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103f8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f95:	e8 d6 07 00 00       	call   80104770 <popcli>
  if(!holding(&ptable.lock))
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 20 0d 12 80       	push   $0x80120d20
80103fa2:	e8 29 08 00 00       	call   801047d0 <holding>
80103fa7:	83 c4 10             	add    $0x10,%esp
80103faa:	85 c0                	test   %eax,%eax
80103fac:	74 4f                	je     80103ffd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fae:	e8 ed fa ff ff       	call   80103aa0 <mycpu>
80103fb3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fba:	75 68                	jne    80104024 <sched+0xa4>
  if(p->state == RUNNING)
80103fbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fc0:	74 55                	je     80104017 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fc2:	9c                   	pushf
80103fc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fc4:	f6 c4 02             	test   $0x2,%ah
80103fc7:	75 41                	jne    8010400a <sched+0x8a>
  intena = mycpu()->intena;
80103fc9:	e8 d2 fa ff ff       	call   80103aa0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fd7:	e8 c4 fa ff ff       	call   80103aa0 <mycpu>
80103fdc:	83 ec 08             	sub    $0x8,%esp
80103fdf:	ff 70 04             	push   0x4(%eax)
80103fe2:	53                   	push   %ebx
80103fe3:	e8 93 0b 00 00       	call   80104b7b <swtch>
  mycpu()->intena = intena;
80103fe8:	e8 b3 fa ff ff       	call   80103aa0 <mycpu>
}
80103fed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ff0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff9:	5b                   	pop    %ebx
80103ffa:	5e                   	pop    %esi
80103ffb:	5d                   	pop    %ebp
80103ffc:	c3                   	ret
    panic("sched ptable.lock");
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	68 11 7a 10 80       	push   $0x80107a11
80104005:	e8 76 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 3d 7a 10 80       	push   $0x80107a3d
80104012:	e8 69 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104017:	83 ec 0c             	sub    $0xc,%esp
8010401a:	68 2f 7a 10 80       	push   $0x80107a2f
8010401f:	e8 5c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104024:	83 ec 0c             	sub    $0xc,%esp
80104027:	68 23 7a 10 80       	push   $0x80107a23
8010402c:	e8 4f c3 ff ff       	call   80100380 <panic>
80104031:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104038:	00 
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <exit>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104049:	e8 d2 fa ff ff       	call   80103b20 <myproc>
  if(curproc == initproc)
8010404e:	39 05 54 2c 12 80    	cmp    %eax,0x80122c54
80104054:	0f 84 fd 00 00 00    	je     80104157 <exit+0x117>
8010405a:	89 c3                	mov    %eax,%ebx
8010405c:	8d 70 28             	lea    0x28(%eax),%esi
8010405f:	8d 78 68             	lea    0x68(%eax),%edi
80104062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104068:	8b 06                	mov    (%esi),%eax
8010406a:	85 c0                	test   %eax,%eax
8010406c:	74 12                	je     80104080 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010406e:	83 ec 0c             	sub    $0xc,%esp
80104071:	50                   	push   %eax
80104072:	e8 99 ce ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80104077:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010407d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104080:	83 c6 04             	add    $0x4,%esi
80104083:	39 f7                	cmp    %esi,%edi
80104085:	75 e1                	jne    80104068 <exit+0x28>
  begin_op();
80104087:	e8 74 ee ff ff       	call   80102f00 <begin_op>
  iput(curproc->cwd);
8010408c:	83 ec 0c             	sub    $0xc,%esp
8010408f:	ff 73 68             	push   0x68(%ebx)
80104092:	e8 39 d8 ff ff       	call   801018d0 <iput>
  end_op();
80104097:	e8 d4 ee ff ff       	call   80102f70 <end_op>
  curproc->cwd = 0;
8010409c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040a3:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
801040aa:	e8 c1 07 00 00       	call   80104870 <acquire>
  wakeup1(curproc->parent);
801040af:	8b 53 14             	mov    0x14(%ebx),%edx
801040b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b5:	b8 54 0d 12 80       	mov    $0x80120d54,%eax
801040ba:	eb 0e                	jmp    801040ca <exit+0x8a>
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c0:	83 c0 7c             	add    $0x7c,%eax
801040c3:	3d 54 2c 12 80       	cmp    $0x80122c54,%eax
801040c8:	74 1c                	je     801040e6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801040ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ce:	75 f0                	jne    801040c0 <exit+0x80>
801040d0:	3b 50 20             	cmp    0x20(%eax),%edx
801040d3:	75 eb                	jne    801040c0 <exit+0x80>
      p->state = RUNNABLE;
801040d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040dc:	83 c0 7c             	add    $0x7c,%eax
801040df:	3d 54 2c 12 80       	cmp    $0x80122c54,%eax
801040e4:	75 e4                	jne    801040ca <exit+0x8a>
      p->parent = initproc;
801040e6:	8b 0d 54 2c 12 80    	mov    0x80122c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	ba 54 0d 12 80       	mov    $0x80120d54,%edx
801040f1:	eb 10                	jmp    80104103 <exit+0xc3>
801040f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801040f8:	83 c2 7c             	add    $0x7c,%edx
801040fb:	81 fa 54 2c 12 80    	cmp    $0x80122c54,%edx
80104101:	74 3b                	je     8010413e <exit+0xfe>
    if(p->parent == curproc){
80104103:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104106:	75 f0                	jne    801040f8 <exit+0xb8>
      if(p->state == ZOMBIE)
80104108:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010410c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010410f:	75 e7                	jne    801040f8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104111:	b8 54 0d 12 80       	mov    $0x80120d54,%eax
80104116:	eb 12                	jmp    8010412a <exit+0xea>
80104118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010411f:	00 
80104120:	83 c0 7c             	add    $0x7c,%eax
80104123:	3d 54 2c 12 80       	cmp    $0x80122c54,%eax
80104128:	74 ce                	je     801040f8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010412a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010412e:	75 f0                	jne    80104120 <exit+0xe0>
80104130:	3b 48 20             	cmp    0x20(%eax),%ecx
80104133:	75 eb                	jne    80104120 <exit+0xe0>
      p->state = RUNNABLE;
80104135:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010413c:	eb e2                	jmp    80104120 <exit+0xe0>
  curproc->state = ZOMBIE;
8010413e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104145:	e8 36 fe ff ff       	call   80103f80 <sched>
  panic("zombie exit");
8010414a:	83 ec 0c             	sub    $0xc,%esp
8010414d:	68 5e 7a 10 80       	push   $0x80107a5e
80104152:	e8 29 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104157:	83 ec 0c             	sub    $0xc,%esp
8010415a:	68 51 7a 10 80       	push   $0x80107a51
8010415f:	e8 1c c2 ff ff       	call   80100380 <panic>
80104164:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010416b:	00 
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104170 <wait>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
  pushcli();
80104175:	e8 a6 05 00 00       	call   80104720 <pushcli>
  c = mycpu();
8010417a:	e8 21 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010417f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104185:	e8 e6 05 00 00       	call   80104770 <popcli>
  acquire(&ptable.lock);
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 20 0d 12 80       	push   $0x80120d20
80104192:	e8 d9 06 00 00       	call   80104870 <acquire>
80104197:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010419a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419c:	bb 54 0d 12 80       	mov    $0x80120d54,%ebx
801041a1:	eb 10                	jmp    801041b3 <wait+0x43>
801041a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801041a8:	83 c3 7c             	add    $0x7c,%ebx
801041ab:	81 fb 54 2c 12 80    	cmp    $0x80122c54,%ebx
801041b1:	74 1b                	je     801041ce <wait+0x5e>
      if(p->parent != curproc)
801041b3:	39 73 14             	cmp    %esi,0x14(%ebx)
801041b6:	75 f0                	jne    801041a8 <wait+0x38>
      if(p->state == ZOMBIE){
801041b8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041bc:	74 62                	je     80104220 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041be:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801041c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c6:	81 fb 54 2c 12 80    	cmp    $0x80122c54,%ebx
801041cc:	75 e5                	jne    801041b3 <wait+0x43>
    if(!havekids || curproc->killed){
801041ce:	85 c0                	test   %eax,%eax
801041d0:	0f 84 a0 00 00 00    	je     80104276 <wait+0x106>
801041d6:	8b 46 24             	mov    0x24(%esi),%eax
801041d9:	85 c0                	test   %eax,%eax
801041db:	0f 85 95 00 00 00    	jne    80104276 <wait+0x106>
  pushcli();
801041e1:	e8 3a 05 00 00       	call   80104720 <pushcli>
  c = mycpu();
801041e6:	e8 b5 f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801041eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f1:	e8 7a 05 00 00       	call   80104770 <popcli>
  if(p == 0)
801041f6:	85 db                	test   %ebx,%ebx
801041f8:	0f 84 8f 00 00 00    	je     8010428d <wait+0x11d>
  p->chan = chan;
801041fe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104201:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104208:	e8 73 fd ff ff       	call   80103f80 <sched>
  p->chan = 0;
8010420d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104214:	eb 84                	jmp    8010419a <wait+0x2a>
80104216:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010421d:	00 
8010421e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104220:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104223:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104226:	ff 73 08             	push   0x8(%ebx)
80104229:	e8 72 e2 ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
8010422e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104235:	5a                   	pop    %edx
80104236:	ff 73 04             	push   0x4(%ebx)
80104239:	e8 52 30 00 00       	call   80107290 <freevm>
        p->pid = 0;
8010423e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104245:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010424c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104250:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104257:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010425e:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
80104265:	e8 a6 05 00 00       	call   80104810 <release>
        return pid;
8010426a:	83 c4 10             	add    $0x10,%esp
}
8010426d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104270:	89 f0                	mov    %esi,%eax
80104272:	5b                   	pop    %ebx
80104273:	5e                   	pop    %esi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret
      release(&ptable.lock);
80104276:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104279:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010427e:	68 20 0d 12 80       	push   $0x80120d20
80104283:	e8 88 05 00 00       	call   80104810 <release>
      return -1;
80104288:	83 c4 10             	add    $0x10,%esp
8010428b:	eb e0                	jmp    8010426d <wait+0xfd>
    panic("sleep");
8010428d:	83 ec 0c             	sub    $0xc,%esp
80104290:	68 6a 7a 10 80       	push   $0x80107a6a
80104295:	e8 e6 c0 ff ff       	call   80100380 <panic>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042a0 <yield>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042a7:	68 20 0d 12 80       	push   $0x80120d20
801042ac:	e8 bf 05 00 00       	call   80104870 <acquire>
  pushcli();
801042b1:	e8 6a 04 00 00       	call   80104720 <pushcli>
  c = mycpu();
801042b6:	e8 e5 f7 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801042bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c1:	e8 aa 04 00 00       	call   80104770 <popcli>
  myproc()->state = RUNNABLE;
801042c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801042cd:	e8 ae fc ff ff       	call   80103f80 <sched>
  release(&ptable.lock);
801042d2:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
801042d9:	e8 32 05 00 00       	call   80104810 <release>
}
801042de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e1:	83 c4 10             	add    $0x10,%esp
801042e4:	c9                   	leave
801042e5:	c3                   	ret
801042e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042ed:	00 
801042ee:	66 90                	xchg   %ax,%ax

801042f0 <sleep>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042ff:	e8 1c 04 00 00       	call   80104720 <pushcli>
  c = mycpu();
80104304:	e8 97 f7 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104309:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010430f:	e8 5c 04 00 00       	call   80104770 <popcli>
  if(p == 0)
80104314:	85 db                	test   %ebx,%ebx
80104316:	0f 84 87 00 00 00    	je     801043a3 <sleep+0xb3>
  if(lk == 0)
8010431c:	85 f6                	test   %esi,%esi
8010431e:	74 76                	je     80104396 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104320:	81 fe 20 0d 12 80    	cmp    $0x80120d20,%esi
80104326:	74 50                	je     80104378 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 20 0d 12 80       	push   $0x80120d20
80104330:	e8 3b 05 00 00       	call   80104870 <acquire>
    release(lk);
80104335:	89 34 24             	mov    %esi,(%esp)
80104338:	e8 d3 04 00 00       	call   80104810 <release>
  p->chan = chan;
8010433d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104340:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104347:	e8 34 fc ff ff       	call   80103f80 <sched>
  p->chan = 0;
8010434c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104353:	c7 04 24 20 0d 12 80 	movl   $0x80120d20,(%esp)
8010435a:	e8 b1 04 00 00       	call   80104810 <release>
    acquire(lk);
8010435f:	83 c4 10             	add    $0x10,%esp
80104362:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104368:	5b                   	pop    %ebx
80104369:	5e                   	pop    %esi
8010436a:	5f                   	pop    %edi
8010436b:	5d                   	pop    %ebp
    acquire(lk);
8010436c:	e9 ff 04 00 00       	jmp    80104870 <acquire>
80104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104378:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010437b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104382:	e8 f9 fb ff ff       	call   80103f80 <sched>
  p->chan = 0;
80104387:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010438e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104391:	5b                   	pop    %ebx
80104392:	5e                   	pop    %esi
80104393:	5f                   	pop    %edi
80104394:	5d                   	pop    %ebp
80104395:	c3                   	ret
    panic("sleep without lk");
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	68 70 7a 10 80       	push   $0x80107a70
8010439e:	e8 dd bf ff ff       	call   80100380 <panic>
    panic("sleep");
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	68 6a 7a 10 80       	push   $0x80107a6a
801043ab:	e8 d0 bf ff ff       	call   80100380 <panic>

801043b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ba:	68 20 0d 12 80       	push   $0x80120d20
801043bf:	e8 ac 04 00 00       	call   80104870 <acquire>
801043c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c7:	b8 54 0d 12 80       	mov    $0x80120d54,%eax
801043cc:	eb 0c                	jmp    801043da <wakeup+0x2a>
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	83 c0 7c             	add    $0x7c,%eax
801043d3:	3d 54 2c 12 80       	cmp    $0x80122c54,%eax
801043d8:	74 1c                	je     801043f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801043da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043de:	75 f0                	jne    801043d0 <wakeup+0x20>
801043e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801043e3:	75 eb                	jne    801043d0 <wakeup+0x20>
      p->state = RUNNABLE;
801043e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ec:	83 c0 7c             	add    $0x7c,%eax
801043ef:	3d 54 2c 12 80       	cmp    $0x80122c54,%eax
801043f4:	75 e4                	jne    801043da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801043f6:	c7 45 08 20 0d 12 80 	movl   $0x80120d20,0x8(%ebp)
}
801043fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104400:	c9                   	leave
  release(&ptable.lock);
80104401:	e9 0a 04 00 00       	jmp    80104810 <release>
80104406:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010440d:	00 
8010440e:	66 90                	xchg   %ax,%ax

80104410 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 10             	sub    $0x10,%esp
80104417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010441a:	68 20 0d 12 80       	push   $0x80120d20
8010441f:	e8 4c 04 00 00       	call   80104870 <acquire>
80104424:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104427:	b8 54 0d 12 80       	mov    $0x80120d54,%eax
8010442c:	eb 0c                	jmp    8010443a <kill+0x2a>
8010442e:	66 90                	xchg   %ax,%ax
80104430:	83 c0 7c             	add    $0x7c,%eax
80104433:	3d 54 2c 12 80       	cmp    $0x80122c54,%eax
80104438:	74 36                	je     80104470 <kill+0x60>
    if(p->pid == pid){
8010443a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010443d:	75 f1                	jne    80104430 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010443f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104443:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010444a:	75 07                	jne    80104453 <kill+0x43>
        p->state = RUNNABLE;
8010444c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 20 0d 12 80       	push   $0x80120d20
8010445b:	e8 b0 03 00 00       	call   80104810 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104463:	83 c4 10             	add    $0x10,%esp
80104466:	31 c0                	xor    %eax,%eax
}
80104468:	c9                   	leave
80104469:	c3                   	ret
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	68 20 0d 12 80       	push   $0x80120d20
80104478:	e8 93 03 00 00       	call   80104810 <release>
}
8010447d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104480:	83 c4 10             	add    $0x10,%esp
80104483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104488:	c9                   	leave
80104489:	c3                   	ret
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104498:	53                   	push   %ebx
80104499:	bb c0 0d 12 80       	mov    $0x80120dc0,%ebx
8010449e:	83 ec 3c             	sub    $0x3c,%esp
801044a1:	eb 24                	jmp    801044c7 <procdump+0x37>
801044a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	68 57 7c 10 80       	push   $0x80107c57
801044b0:	e8 fb c1 ff ff       	call   801006b0 <cprintf>
801044b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b8:	83 c3 7c             	add    $0x7c,%ebx
801044bb:	81 fb c0 2c 12 80    	cmp    $0x80122cc0,%ebx
801044c1:	0f 84 81 00 00 00    	je     80104548 <procdump+0xb8>
    if(p->state == UNUSED)
801044c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044ca:	85 c0                	test   %eax,%eax
801044cc:	74 ea                	je     801044b8 <procdump+0x28>
      state = "???";
801044ce:	ba 81 7a 10 80       	mov    $0x80107a81,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044d3:	83 f8 05             	cmp    $0x5,%eax
801044d6:	77 11                	ja     801044e9 <procdump+0x59>
801044d8:	8b 14 85 e0 80 10 80 	mov    -0x7fef7f20(,%eax,4),%edx
      state = "???";
801044df:	b8 81 7a 10 80       	mov    $0x80107a81,%eax
801044e4:	85 d2                	test   %edx,%edx
801044e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044e9:	53                   	push   %ebx
801044ea:	52                   	push   %edx
801044eb:	ff 73 a4             	push   -0x5c(%ebx)
801044ee:	68 85 7a 10 80       	push   $0x80107a85
801044f3:	e8 b8 c1 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801044f8:	83 c4 10             	add    $0x10,%esp
801044fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044ff:	75 a7                	jne    801044a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104501:	83 ec 08             	sub    $0x8,%esp
80104504:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104507:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010450a:	50                   	push   %eax
8010450b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010450e:	8b 40 0c             	mov    0xc(%eax),%eax
80104511:	83 c0 08             	add    $0x8,%eax
80104514:	50                   	push   %eax
80104515:	e8 86 01 00 00       	call   801046a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
80104520:	8b 17                	mov    (%edi),%edx
80104522:	85 d2                	test   %edx,%edx
80104524:	74 82                	je     801044a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104526:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104529:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010452c:	52                   	push   %edx
8010452d:	68 c1 77 10 80       	push   $0x801077c1
80104532:	e8 79 c1 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104537:	83 c4 10             	add    $0x10,%esp
8010453a:	39 f7                	cmp    %esi,%edi
8010453c:	75 e2                	jne    80104520 <procdump+0x90>
8010453e:	e9 65 ff ff ff       	jmp    801044a8 <procdump+0x18>
80104543:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104548:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010454b:	5b                   	pop    %ebx
8010454c:	5e                   	pop    %esi
8010454d:	5f                   	pop    %edi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret

80104550 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 0c             	sub    $0xc,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010455a:	68 b8 7a 10 80       	push   $0x80107ab8
8010455f:	8d 43 04             	lea    0x4(%ebx),%eax
80104562:	50                   	push   %eax
80104563:	e8 18 01 00 00       	call   80104680 <initlock>
  lk->name = name;
80104568:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010456b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104571:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104574:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010457b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010457e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104581:	c9                   	leave
80104582:	c3                   	ret
80104583:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010458a:	00 
8010458b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104590 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	8d 73 04             	lea    0x4(%ebx),%esi
8010459b:	83 ec 0c             	sub    $0xc,%esp
8010459e:	56                   	push   %esi
8010459f:	e8 cc 02 00 00       	call   80104870 <acquire>
  while (lk->locked) {
801045a4:	8b 13                	mov    (%ebx),%edx
801045a6:	83 c4 10             	add    $0x10,%esp
801045a9:	85 d2                	test   %edx,%edx
801045ab:	74 16                	je     801045c3 <acquiresleep+0x33>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045b0:	83 ec 08             	sub    $0x8,%esp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	e8 36 fd ff ff       	call   801042f0 <sleep>
  while (lk->locked) {
801045ba:	8b 03                	mov    (%ebx),%eax
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	85 c0                	test   %eax,%eax
801045c1:	75 ed                	jne    801045b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045c9:	e8 52 f5 ff ff       	call   80103b20 <myproc>
801045ce:	8b 40 10             	mov    0x10(%eax),%eax
801045d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045da:	5b                   	pop    %ebx
801045db:	5e                   	pop    %esi
801045dc:	5d                   	pop    %ebp
  release(&lk->lk);
801045dd:	e9 2e 02 00 00       	jmp    80104810 <release>
801045e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045e9:	00 
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045f8:	8d 73 04             	lea    0x4(%ebx),%esi
801045fb:	83 ec 0c             	sub    $0xc,%esp
801045fe:	56                   	push   %esi
801045ff:	e8 6c 02 00 00       	call   80104870 <acquire>
  lk->locked = 0;
80104604:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010460a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104611:	89 1c 24             	mov    %ebx,(%esp)
80104614:	e8 97 fd ff ff       	call   801043b0 <wakeup>
  release(&lk->lk);
80104619:	83 c4 10             	add    $0x10,%esp
8010461c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010461f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5d                   	pop    %ebp
  release(&lk->lk);
80104625:	e9 e6 01 00 00       	jmp    80104810 <release>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	31 ff                	xor    %edi,%edi
80104636:	56                   	push   %esi
80104637:	53                   	push   %ebx
80104638:	83 ec 18             	sub    $0x18,%esp
8010463b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010463e:	8d 73 04             	lea    0x4(%ebx),%esi
80104641:	56                   	push   %esi
80104642:	e8 29 02 00 00       	call   80104870 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104647:	8b 03                	mov    (%ebx),%eax
80104649:	83 c4 10             	add    $0x10,%esp
8010464c:	85 c0                	test   %eax,%eax
8010464e:	75 18                	jne    80104668 <holdingsleep+0x38>
  release(&lk->lk);
80104650:	83 ec 0c             	sub    $0xc,%esp
80104653:	56                   	push   %esi
80104654:	e8 b7 01 00 00       	call   80104810 <release>
  return r;
}
80104659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010465c:	89 f8                	mov    %edi,%eax
8010465e:	5b                   	pop    %ebx
8010465f:	5e                   	pop    %esi
80104660:	5f                   	pop    %edi
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret
80104663:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104668:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010466b:	e8 b0 f4 ff ff       	call   80103b20 <myproc>
80104670:	39 58 10             	cmp    %ebx,0x10(%eax)
80104673:	0f 94 c0             	sete   %al
80104676:	0f b6 c0             	movzbl %al,%eax
80104679:	89 c7                	mov    %eax,%edi
8010467b:	eb d3                	jmp    80104650 <holdingsleep+0x20>
8010467d:	66 90                	xchg   %ax,%ax
8010467f:	90                   	nop

80104680 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104686:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010468f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104692:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret
8010469b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	8b 45 08             	mov    0x8(%ebp),%eax
801046a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801046aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046ad:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801046b2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801046b7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046bc:	76 10                	jbe    801046ce <getcallerpcs+0x2e>
801046be:	eb 28                	jmp    801046e8 <getcallerpcs+0x48>
801046c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801046c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046cc:	77 1a                	ja     801046e8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801046d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801046d4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801046d7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801046d9:	83 f8 0a             	cmp    $0xa,%eax
801046dc:	75 e2                	jne    801046c0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e1:	c9                   	leave
801046e2:	c3                   	ret
801046e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801046e8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801046eb:	83 c1 28             	add    $0x28,%ecx
801046ee:	89 ca                	mov    %ecx,%edx
801046f0:	29 c2                	sub    %eax,%edx
801046f2:	83 e2 04             	and    $0x4,%edx
801046f5:	74 11                	je     80104708 <getcallerpcs+0x68>
    pcs[i] = 0;
801046f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046fd:	83 c0 04             	add    $0x4,%eax
80104700:	39 c1                	cmp    %eax,%ecx
80104702:	74 da                	je     801046de <getcallerpcs+0x3e>
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010470e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104711:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104718:	39 c1                	cmp    %eax,%ecx
8010471a:	75 ec                	jne    80104708 <getcallerpcs+0x68>
8010471c:	eb c0                	jmp    801046de <getcallerpcs+0x3e>
8010471e:	66 90                	xchg   %ax,%ax

80104720 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
80104727:	9c                   	pushf
80104728:	5b                   	pop    %ebx
  asm volatile("cli");
80104729:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010472a:	e8 71 f3 ff ff       	call   80103aa0 <mycpu>
8010472f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	74 17                	je     80104750 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104739:	e8 62 f3 ff ff       	call   80103aa0 <mycpu>
8010473e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104748:	c9                   	leave
80104749:	c3                   	ret
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104750:	e8 4b f3 ff ff       	call   80103aa0 <mycpu>
80104755:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010475b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104761:	eb d6                	jmp    80104739 <pushcli+0x19>
80104763:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010476a:	00 
8010476b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104770 <popcli>:

void
popcli(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104776:	9c                   	pushf
80104777:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104778:	f6 c4 02             	test   $0x2,%ah
8010477b:	75 35                	jne    801047b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010477d:	e8 1e f3 ff ff       	call   80103aa0 <mycpu>
80104782:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104789:	78 34                	js     801047bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010478b:	e8 10 f3 ff ff       	call   80103aa0 <mycpu>
80104790:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104796:	85 d2                	test   %edx,%edx
80104798:	74 06                	je     801047a0 <popcli+0x30>
    sti();
}
8010479a:	c9                   	leave
8010479b:	c3                   	ret
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047a0:	e8 fb f2 ff ff       	call   80103aa0 <mycpu>
801047a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047ab:	85 c0                	test   %eax,%eax
801047ad:	74 eb                	je     8010479a <popcli+0x2a>
  asm volatile("sti");
801047af:	fb                   	sti
}
801047b0:	c9                   	leave
801047b1:	c3                   	ret
    panic("popcli - interruptible");
801047b2:	83 ec 0c             	sub    $0xc,%esp
801047b5:	68 c3 7a 10 80       	push   $0x80107ac3
801047ba:	e8 c1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	68 da 7a 10 80       	push   $0x80107ada
801047c7:	e8 b4 bb ff ff       	call   80100380 <panic>
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <holding>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 75 08             	mov    0x8(%ebp),%esi
801047d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047da:	e8 41 ff ff ff       	call   80104720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047df:	8b 06                	mov    (%esi),%eax
801047e1:	85 c0                	test   %eax,%eax
801047e3:	75 0b                	jne    801047f0 <holding+0x20>
  popcli();
801047e5:	e8 86 ff ff ff       	call   80104770 <popcli>
}
801047ea:	89 d8                	mov    %ebx,%eax
801047ec:	5b                   	pop    %ebx
801047ed:	5e                   	pop    %esi
801047ee:	5d                   	pop    %ebp
801047ef:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801047f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801047f3:	e8 a8 f2 ff ff       	call   80103aa0 <mycpu>
801047f8:	39 c3                	cmp    %eax,%ebx
801047fa:	0f 94 c3             	sete   %bl
  popcli();
801047fd:	e8 6e ff ff ff       	call   80104770 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104802:	0f b6 db             	movzbl %bl,%ebx
}
80104805:	89 d8                	mov    %ebx,%eax
80104807:	5b                   	pop    %ebx
80104808:	5e                   	pop    %esi
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret
8010480b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104810 <release>:
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104818:	e8 03 ff ff ff       	call   80104720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010481d:	8b 03                	mov    (%ebx),%eax
8010481f:	85 c0                	test   %eax,%eax
80104821:	75 15                	jne    80104838 <release+0x28>
  popcli();
80104823:	e8 48 ff ff ff       	call   80104770 <popcli>
    panic("release");
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 e1 7a 10 80       	push   $0x80107ae1
80104830:	e8 4b bb ff ff       	call   80100380 <panic>
80104835:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104838:	8b 73 08             	mov    0x8(%ebx),%esi
8010483b:	e8 60 f2 ff ff       	call   80103aa0 <mycpu>
80104840:	39 c6                	cmp    %eax,%esi
80104842:	75 df                	jne    80104823 <release+0x13>
  popcli();
80104844:	e8 27 ff ff ff       	call   80104770 <popcli>
  lk->pcs[0] = 0;
80104849:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104850:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104857:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010485c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104862:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104865:	5b                   	pop    %ebx
80104866:	5e                   	pop    %esi
80104867:	5d                   	pop    %ebp
  popcli();
80104868:	e9 03 ff ff ff       	jmp    80104770 <popcli>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi

80104870 <acquire>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104877:	e8 a4 fe ff ff       	call   80104720 <pushcli>
  if(holding(lk))
8010487c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010487f:	e8 9c fe ff ff       	call   80104720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104884:	8b 03                	mov    (%ebx),%eax
80104886:	85 c0                	test   %eax,%eax
80104888:	0f 85 b2 00 00 00    	jne    80104940 <acquire+0xd0>
  popcli();
8010488e:	e8 dd fe ff ff       	call   80104770 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104893:	b9 01 00 00 00       	mov    $0x1,%ecx
80104898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010489f:	00 
  while(xchg(&lk->locked, 1) != 0)
801048a0:	8b 55 08             	mov    0x8(%ebp),%edx
801048a3:	89 c8                	mov    %ecx,%eax
801048a5:	f0 87 02             	lock xchg %eax,(%edx)
801048a8:	85 c0                	test   %eax,%eax
801048aa:	75 f4                	jne    801048a0 <acquire+0x30>
  __sync_synchronize();
801048ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048b4:	e8 e7 f1 ff ff       	call   80103aa0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801048bc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801048be:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048c1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801048c7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801048cc:	77 32                	ja     80104900 <acquire+0x90>
  ebp = (uint*)v - 2;
801048ce:	89 e8                	mov    %ebp,%eax
801048d0:	eb 14                	jmp    801048e6 <acquire+0x76>
801048d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048d8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801048de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048e4:	77 1a                	ja     80104900 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801048e6:	8b 58 04             	mov    0x4(%eax),%ebx
801048e9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801048ed:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801048f0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048f2:	83 fa 0a             	cmp    $0xa,%edx
801048f5:	75 e1                	jne    801048d8 <acquire+0x68>
}
801048f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048fa:	c9                   	leave
801048fb:	c3                   	ret
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104900:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104904:	83 c1 34             	add    $0x34,%ecx
80104907:	89 ca                	mov    %ecx,%edx
80104909:	29 c2                	sub    %eax,%edx
8010490b:	83 e2 04             	and    $0x4,%edx
8010490e:	74 10                	je     80104920 <acquire+0xb0>
    pcs[i] = 0;
80104910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104916:	83 c0 04             	add    $0x4,%eax
80104919:	39 c1                	cmp    %eax,%ecx
8010491b:	74 da                	je     801048f7 <acquire+0x87>
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104926:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104929:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104930:	39 c1                	cmp    %eax,%ecx
80104932:	75 ec                	jne    80104920 <acquire+0xb0>
80104934:	eb c1                	jmp    801048f7 <acquire+0x87>
80104936:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010493d:	00 
8010493e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104940:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104943:	e8 58 f1 ff ff       	call   80103aa0 <mycpu>
80104948:	39 c3                	cmp    %eax,%ebx
8010494a:	0f 85 3e ff ff ff    	jne    8010488e <acquire+0x1e>
  popcli();
80104950:	e8 1b fe ff ff       	call   80104770 <popcli>
    panic("acquire");
80104955:	83 ec 0c             	sub    $0xc,%esp
80104958:	68 e9 7a 10 80       	push   $0x80107ae9
8010495d:	e8 1e ba ff ff       	call   80100380 <panic>
80104962:	66 90                	xchg   %ax,%ax
80104964:	66 90                	xchg   %ax,%ax
80104966:	66 90                	xchg   %ax,%ax
80104968:	66 90                	xchg   %ax,%ax
8010496a:	66 90                	xchg   %ax,%ax
8010496c:	66 90                	xchg   %ax,%ax
8010496e:	66 90                	xchg   %ax,%ax

80104970 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	8b 55 08             	mov    0x8(%ebp),%edx
80104977:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010497a:	89 d0                	mov    %edx,%eax
8010497c:	09 c8                	or     %ecx,%eax
8010497e:	a8 03                	test   $0x3,%al
80104980:	75 1e                	jne    801049a0 <memset+0x30>
    c &= 0xFF;
80104982:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104986:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104989:	89 d7                	mov    %edx,%edi
8010498b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104991:	fc                   	cld
80104992:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104994:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104997:	89 d0                	mov    %edx,%eax
80104999:	c9                   	leave
8010499a:	c3                   	ret
8010499b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049a3:	89 d7                	mov    %edx,%edi
801049a5:	fc                   	cld
801049a6:	f3 aa                	rep stos %al,%es:(%edi)
801049a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801049ab:	89 d0                	mov    %edx,%eax
801049ad:	c9                   	leave
801049ae:	c3                   	ret
801049af:	90                   	nop

801049b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	8b 75 10             	mov    0x10(%ebp),%esi
801049b7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ba:	53                   	push   %ebx
801049bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049be:	85 f6                	test   %esi,%esi
801049c0:	74 2e                	je     801049f0 <memcmp+0x40>
801049c2:	01 c6                	add    %eax,%esi
801049c4:	eb 14                	jmp    801049da <memcmp+0x2a>
801049c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049cd:	00 
801049ce:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049d0:	83 c0 01             	add    $0x1,%eax
801049d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049d6:	39 f0                	cmp    %esi,%eax
801049d8:	74 16                	je     801049f0 <memcmp+0x40>
    if(*s1 != *s2)
801049da:	0f b6 08             	movzbl (%eax),%ecx
801049dd:	0f b6 1a             	movzbl (%edx),%ebx
801049e0:	38 d9                	cmp    %bl,%cl
801049e2:	74 ec                	je     801049d0 <memcmp+0x20>
      return *s1 - *s2;
801049e4:	0f b6 c1             	movzbl %cl,%eax
801049e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049e9:	5b                   	pop    %ebx
801049ea:	5e                   	pop    %esi
801049eb:	5d                   	pop    %ebp
801049ec:	c3                   	ret
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
801049f0:	5b                   	pop    %ebx
  return 0;
801049f1:	31 c0                	xor    %eax,%eax
}
801049f3:	5e                   	pop    %esi
801049f4:	5d                   	pop    %ebp
801049f5:	c3                   	ret
801049f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049fd:	00 
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	8b 55 08             	mov    0x8(%ebp),%edx
80104a07:	8b 45 10             	mov    0x10(%ebp),%eax
80104a0a:	56                   	push   %esi
80104a0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a0e:	39 d6                	cmp    %edx,%esi
80104a10:	73 26                	jae    80104a38 <memmove+0x38>
80104a12:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104a15:	39 ca                	cmp    %ecx,%edx
80104a17:	73 1f                	jae    80104a38 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a19:	85 c0                	test   %eax,%eax
80104a1b:	74 0f                	je     80104a2c <memmove+0x2c>
80104a1d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104a20:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a24:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a27:	83 e8 01             	sub    $0x1,%eax
80104a2a:	73 f4                	jae    80104a20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a2c:	5e                   	pop    %esi
80104a2d:	89 d0                	mov    %edx,%eax
80104a2f:	5f                   	pop    %edi
80104a30:	5d                   	pop    %ebp
80104a31:	c3                   	ret
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a38:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104a3b:	89 d7                	mov    %edx,%edi
80104a3d:	85 c0                	test   %eax,%eax
80104a3f:	74 eb                	je     80104a2c <memmove+0x2c>
80104a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a48:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a49:	39 ce                	cmp    %ecx,%esi
80104a4b:	75 fb                	jne    80104a48 <memmove+0x48>
}
80104a4d:	5e                   	pop    %esi
80104a4e:	89 d0                	mov    %edx,%eax
80104a50:	5f                   	pop    %edi
80104a51:	5d                   	pop    %ebp
80104a52:	c3                   	ret
80104a53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a5a:	00 
80104a5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a60:	eb 9e                	jmp    80104a00 <memmove>
80104a62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a69:	00 
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	8b 55 10             	mov    0x10(%ebp),%edx
80104a77:	8b 45 08             	mov    0x8(%ebp),%eax
80104a7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104a7d:	85 d2                	test   %edx,%edx
80104a7f:	75 16                	jne    80104a97 <strncmp+0x27>
80104a81:	eb 2d                	jmp    80104ab0 <strncmp+0x40>
80104a83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a88:	3a 19                	cmp    (%ecx),%bl
80104a8a:	75 12                	jne    80104a9e <strncmp+0x2e>
    n--, p++, q++;
80104a8c:	83 c0 01             	add    $0x1,%eax
80104a8f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a92:	83 ea 01             	sub    $0x1,%edx
80104a95:	74 19                	je     80104ab0 <strncmp+0x40>
80104a97:	0f b6 18             	movzbl (%eax),%ebx
80104a9a:	84 db                	test   %bl,%bl
80104a9c:	75 ea                	jne    80104a88 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a9e:	0f b6 00             	movzbl (%eax),%eax
80104aa1:	0f b6 11             	movzbl (%ecx),%edx
}
80104aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104aa8:	29 d0                	sub    %edx,%eax
}
80104aaa:	c3                   	ret
80104aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104ab3:	31 c0                	xor    %eax,%eax
}
80104ab5:	c9                   	leave
80104ab6:	c3                   	ret
80104ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104abe:	00 
80104abf:	90                   	nop

80104ac0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ac8:	53                   	push   %ebx
80104ac9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104acc:	89 f0                	mov    %esi,%eax
80104ace:	eb 15                	jmp    80104ae5 <strncpy+0x25>
80104ad0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ad4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ad7:	83 c0 01             	add    $0x1,%eax
80104ada:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104ade:	88 48 ff             	mov    %cl,-0x1(%eax)
80104ae1:	84 c9                	test   %cl,%cl
80104ae3:	74 13                	je     80104af8 <strncpy+0x38>
80104ae5:	89 d3                	mov    %edx,%ebx
80104ae7:	83 ea 01             	sub    $0x1,%edx
80104aea:	85 db                	test   %ebx,%ebx
80104aec:	7f e2                	jg     80104ad0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104aee:	5b                   	pop    %ebx
80104aef:	89 f0                	mov    %esi,%eax
80104af1:	5e                   	pop    %esi
80104af2:	5f                   	pop    %edi
80104af3:	5d                   	pop    %ebp
80104af4:	c3                   	ret
80104af5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104af8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104afb:	83 e9 01             	sub    $0x1,%ecx
80104afe:	85 d2                	test   %edx,%edx
80104b00:	74 ec                	je     80104aee <strncpy+0x2e>
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104b08:	83 c0 01             	add    $0x1,%eax
80104b0b:	89 ca                	mov    %ecx,%edx
80104b0d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104b11:	29 c2                	sub    %eax,%edx
80104b13:	85 d2                	test   %edx,%edx
80104b15:	7f f1                	jg     80104b08 <strncpy+0x48>
}
80104b17:	5b                   	pop    %ebx
80104b18:	89 f0                	mov    %esi,%eax
80104b1a:	5e                   	pop    %esi
80104b1b:	5f                   	pop    %edi
80104b1c:	5d                   	pop    %ebp
80104b1d:	c3                   	ret
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	8b 55 10             	mov    0x10(%ebp),%edx
80104b27:	8b 75 08             	mov    0x8(%ebp),%esi
80104b2a:	53                   	push   %ebx
80104b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b2e:	85 d2                	test   %edx,%edx
80104b30:	7e 25                	jle    80104b57 <safestrcpy+0x37>
80104b32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b36:	89 f2                	mov    %esi,%edx
80104b38:	eb 16                	jmp    80104b50 <safestrcpy+0x30>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b40:	0f b6 08             	movzbl (%eax),%ecx
80104b43:	83 c0 01             	add    $0x1,%eax
80104b46:	83 c2 01             	add    $0x1,%edx
80104b49:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b4c:	84 c9                	test   %cl,%cl
80104b4e:	74 04                	je     80104b54 <safestrcpy+0x34>
80104b50:	39 d8                	cmp    %ebx,%eax
80104b52:	75 ec                	jne    80104b40 <safestrcpy+0x20>
    ;
  *s = 0;
80104b54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b57:	89 f0                	mov    %esi,%eax
80104b59:	5b                   	pop    %ebx
80104b5a:	5e                   	pop    %esi
80104b5b:	5d                   	pop    %ebp
80104b5c:	c3                   	ret
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi

80104b60 <strlen>:

int
strlen(const char *s)
{
80104b60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b61:	31 c0                	xor    %eax,%eax
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b68:	80 3a 00             	cmpb   $0x0,(%edx)
80104b6b:	74 0c                	je     80104b79 <strlen+0x19>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b77:	75 f7                	jne    80104b70 <strlen+0x10>
    ;
  return n;
}
80104b79:	5d                   	pop    %ebp
80104b7a:	c3                   	ret

80104b7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b83:	55                   	push   %ebp
  pushl %ebx
80104b84:	53                   	push   %ebx
  pushl %esi
80104b85:	56                   	push   %esi
  pushl %edi
80104b86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b8b:	5f                   	pop    %edi
  popl %esi
80104b8c:	5e                   	pop    %esi
  popl %ebx
80104b8d:	5b                   	pop    %ebx
  popl %ebp
80104b8e:	5d                   	pop    %ebp
  ret
80104b8f:	c3                   	ret

80104b90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
80104b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b9a:	e8 81 ef ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b9f:	8b 00                	mov    (%eax),%eax
80104ba1:	39 c3                	cmp    %eax,%ebx
80104ba3:	73 1b                	jae    80104bc0 <fetchint+0x30>
80104ba5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ba8:	39 d0                	cmp    %edx,%eax
80104baa:	72 14                	jb     80104bc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104baf:	8b 13                	mov    (%ebx),%edx
80104bb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb3:	31 c0                	xor    %eax,%eax
}
80104bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb8:	c9                   	leave
80104bb9:	c3                   	ret
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ee                	jmp    80104bb5 <fetchint+0x25>
80104bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bce:	00 
80104bcf:	90                   	nop

80104bd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bda:	e8 41 ef ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz)
80104bdf:	3b 18                	cmp    (%eax),%ebx
80104be1:	73 2d                	jae    80104c10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104be3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104be6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104be8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bea:	39 d3                	cmp    %edx,%ebx
80104bec:	73 22                	jae    80104c10 <fetchstr+0x40>
80104bee:	89 d8                	mov    %ebx,%eax
80104bf0:	eb 0d                	jmp    80104bff <fetchstr+0x2f>
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf8:	83 c0 01             	add    $0x1,%eax
80104bfb:	39 d0                	cmp    %edx,%eax
80104bfd:	73 11                	jae    80104c10 <fetchstr+0x40>
    if(*s == 0)
80104bff:	80 38 00             	cmpb   $0x0,(%eax)
80104c02:	75 f4                	jne    80104bf8 <fetchstr+0x28>
      return s - *pp;
80104c04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c09:	c9                   	leave
80104c0a:	c3                   	ret
80104c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c18:	c9                   	leave
80104c19:	c3                   	ret
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 f6 ee ff ff       	call   80103b20 <myproc>
80104c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2d:	8b 40 18             	mov    0x18(%eax),%eax
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 e5 ee ff ff       	call   80103b20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3e:	8b 00                	mov    (%eax),%eax
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 1c                	jae    80104c60 <argint+0x40>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 15                	jb     80104c60 <argint+0x40>
  *ip = *(int*)(addr);
80104c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	5b                   	pop    %ebx
80104c56:	5e                   	pop    %esi
80104c57:	5d                   	pop    %ebp
80104c58:	c3                   	ret
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	eb ee                	jmp    80104c55 <argint+0x35>
80104c67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c6e:	00 
80104c6f:	90                   	nop

80104c70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c79:	e8 a2 ee ff ff       	call   80103b20 <myproc>
80104c7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c80:	e8 9b ee ff ff       	call   80103b20 <myproc>
80104c85:	8b 55 08             	mov    0x8(%ebp),%edx
80104c88:	8b 40 18             	mov    0x18(%eax),%eax
80104c8b:	8b 40 44             	mov    0x44(%eax),%eax
80104c8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c91:	e8 8a ee ff ff       	call   80103b20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c99:	8b 00                	mov    (%eax),%eax
80104c9b:	39 c7                	cmp    %eax,%edi
80104c9d:	73 31                	jae    80104cd0 <argptr+0x60>
80104c9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ca2:	39 c8                	cmp    %ecx,%eax
80104ca4:	72 2a                	jb     80104cd0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ca6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ca9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cac:	85 d2                	test   %edx,%edx
80104cae:	78 20                	js     80104cd0 <argptr+0x60>
80104cb0:	8b 16                	mov    (%esi),%edx
80104cb2:	39 d0                	cmp    %edx,%eax
80104cb4:	73 1a                	jae    80104cd0 <argptr+0x60>
80104cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cb9:	01 c3                	add    %eax,%ebx
80104cbb:	39 da                	cmp    %ebx,%edx
80104cbd:	72 11                	jb     80104cd0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc4:	31 c0                	xor    %eax,%eax
}
80104cc6:	83 c4 0c             	add    $0xc,%esp
80104cc9:	5b                   	pop    %ebx
80104cca:	5e                   	pop    %esi
80104ccb:	5f                   	pop    %edi
80104ccc:	5d                   	pop    %ebp
80104ccd:	c3                   	ret
80104cce:	66 90                	xchg   %ax,%ax
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb ef                	jmp    80104cc6 <argptr+0x56>
80104cd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cde:	00 
80104cdf:	90                   	nop

80104ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce5:	e8 36 ee ff ff       	call   80103b20 <myproc>
80104cea:	8b 55 08             	mov    0x8(%ebp),%edx
80104ced:	8b 40 18             	mov    0x18(%eax),%eax
80104cf0:	8b 40 44             	mov    0x44(%eax),%eax
80104cf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cf6:	e8 25 ee ff ff       	call   80103b20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cfe:	8b 00                	mov    (%eax),%eax
80104d00:	39 c6                	cmp    %eax,%esi
80104d02:	73 44                	jae    80104d48 <argstr+0x68>
80104d04:	8d 53 08             	lea    0x8(%ebx),%edx
80104d07:	39 d0                	cmp    %edx,%eax
80104d09:	72 3d                	jb     80104d48 <argstr+0x68>
  *ip = *(int*)(addr);
80104d0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d0e:	e8 0d ee ff ff       	call   80103b20 <myproc>
  if(addr >= curproc->sz)
80104d13:	3b 18                	cmp    (%eax),%ebx
80104d15:	73 31                	jae    80104d48 <argstr+0x68>
  *pp = (char*)addr;
80104d17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d1e:	39 d3                	cmp    %edx,%ebx
80104d20:	73 26                	jae    80104d48 <argstr+0x68>
80104d22:	89 d8                	mov    %ebx,%eax
80104d24:	eb 11                	jmp    80104d37 <argstr+0x57>
80104d26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d2d:	00 
80104d2e:	66 90                	xchg   %ax,%ax
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	39 d0                	cmp    %edx,%eax
80104d35:	73 11                	jae    80104d48 <argstr+0x68>
    if(*s == 0)
80104d37:	80 38 00             	cmpb   $0x0,(%eax)
80104d3a:	75 f4                	jne    80104d30 <argstr+0x50>
      return s - *pp;
80104d3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d3e:	5b                   	pop    %ebx
80104d3f:	5e                   	pop    %esi
80104d40:	5d                   	pop    %ebp
80104d41:	c3                   	ret
80104d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d48:	5b                   	pop    %ebx
    return -1;
80104d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d4e:	5e                   	pop    %esi
80104d4f:	5d                   	pop    %ebp
80104d50:	c3                   	ret
80104d51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d58:	00 
80104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d60 <syscall>:
[SYS_cowfork]   sys_cowfork,
};

void
syscall(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d67:	e8 b4 ed ff ff       	call   80103b20 <myproc>
80104d6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d6e:	8b 40 18             	mov    0x18(%eax),%eax
80104d71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d77:	83 fa 17             	cmp    $0x17,%edx
80104d7a:	77 24                	ja     80104da0 <syscall+0x40>
80104d7c:	8b 14 85 00 81 10 80 	mov    -0x7fef7f00(,%eax,4),%edx
80104d83:	85 d2                	test   %edx,%edx
80104d85:	74 19                	je     80104da0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d87:	ff d2                	call   *%edx
80104d89:	89 c2                	mov    %eax,%edx
80104d8b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d94:	c9                   	leave
80104d95:	c3                   	ret
80104d96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d9d:	00 
80104d9e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104da0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104da1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104da4:	50                   	push   %eax
80104da5:	ff 73 10             	push   0x10(%ebx)
80104da8:	68 f1 7a 10 80       	push   $0x80107af1
80104dad:	e8 fe b8 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104db2:	8b 43 18             	mov    0x18(%ebx),%eax
80104db5:	83 c4 10             	add    $0x10,%esp
80104db8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc2:	c9                   	leave
80104dc3:	c3                   	ret
80104dc4:	66 90                	xchg   %ax,%ax
80104dc6:	66 90                	xchg   %ax,%ax
80104dc8:	66 90                	xchg   %ax,%ax
80104dca:	66 90                	xchg   %ax,%ax
80104dcc:	66 90                	xchg   %ax,%ax
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104dd8:	53                   	push   %ebx
80104dd9:	83 ec 34             	sub    $0x34,%esp
80104ddc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104de2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104de5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104de8:	57                   	push   %edi
80104de9:	50                   	push   %eax
80104dea:	e8 b1 d2 ff ff       	call   801020a0 <nameiparent>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	74 5e                	je     80104e54 <create+0x84>
    return 0;
  ilock(dp);
80104df6:	83 ec 0c             	sub    $0xc,%esp
80104df9:	89 c3                	mov    %eax,%ebx
80104dfb:	50                   	push   %eax
80104dfc:	e8 9f c9 ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e01:	83 c4 0c             	add    $0xc,%esp
80104e04:	6a 00                	push   $0x0
80104e06:	57                   	push   %edi
80104e07:	53                   	push   %ebx
80104e08:	e8 e3 ce ff ff       	call   80101cf0 <dirlookup>
80104e0d:	83 c4 10             	add    $0x10,%esp
80104e10:	89 c6                	mov    %eax,%esi
80104e12:	85 c0                	test   %eax,%eax
80104e14:	74 4a                	je     80104e60 <create+0x90>
    iunlockput(dp);
80104e16:	83 ec 0c             	sub    $0xc,%esp
80104e19:	53                   	push   %ebx
80104e1a:	e8 11 cc ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104e1f:	89 34 24             	mov    %esi,(%esp)
80104e22:	e8 79 c9 ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e27:	83 c4 10             	add    $0x10,%esp
80104e2a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e2f:	75 17                	jne    80104e48 <create+0x78>
80104e31:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e36:	75 10                	jne    80104e48 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3b:	89 f0                	mov    %esi,%eax
80104e3d:	5b                   	pop    %ebx
80104e3e:	5e                   	pop    %esi
80104e3f:	5f                   	pop    %edi
80104e40:	5d                   	pop    %ebp
80104e41:	c3                   	ret
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	56                   	push   %esi
80104e4c:	e8 df cb ff ff       	call   80101a30 <iunlockput>
    return 0;
80104e51:	83 c4 10             	add    $0x10,%esp
}
80104e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e57:	31 f6                	xor    %esi,%esi
}
80104e59:	5b                   	pop    %ebx
80104e5a:	89 f0                	mov    %esi,%eax
80104e5c:	5e                   	pop    %esi
80104e5d:	5f                   	pop    %edi
80104e5e:	5d                   	pop    %ebp
80104e5f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104e60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e64:	83 ec 08             	sub    $0x8,%esp
80104e67:	50                   	push   %eax
80104e68:	ff 33                	push   (%ebx)
80104e6a:	e8 c1 c7 ff ff       	call   80101630 <ialloc>
80104e6f:	83 c4 10             	add    $0x10,%esp
80104e72:	89 c6                	mov    %eax,%esi
80104e74:	85 c0                	test   %eax,%eax
80104e76:	0f 84 bc 00 00 00    	je     80104f38 <create+0x168>
  ilock(ip);
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	50                   	push   %eax
80104e80:	e8 1b c9 ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104e85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e95:	b8 01 00 00 00       	mov    $0x1,%eax
80104e9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e9e:	89 34 24             	mov    %esi,(%esp)
80104ea1:	e8 4a c8 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104eae:	74 30                	je     80104ee0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104eb0:	83 ec 04             	sub    $0x4,%esp
80104eb3:	ff 76 04             	push   0x4(%esi)
80104eb6:	57                   	push   %edi
80104eb7:	53                   	push   %ebx
80104eb8:	e8 03 d1 ff ff       	call   80101fc0 <dirlink>
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	78 67                	js     80104f2b <create+0x15b>
  iunlockput(dp);
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	53                   	push   %ebx
80104ec8:	e8 63 cb ff ff       	call   80101a30 <iunlockput>
  return ip;
80104ecd:	83 c4 10             	add    $0x10,%esp
}
80104ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed3:	89 f0                	mov    %esi,%eax
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5f                   	pop    %edi
80104ed8:	5d                   	pop    %ebp
80104ed9:	c3                   	ret
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ee3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ee8:	53                   	push   %ebx
80104ee9:	e8 02 c8 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eee:	83 c4 0c             	add    $0xc,%esp
80104ef1:	ff 76 04             	push   0x4(%esi)
80104ef4:	68 29 7b 10 80       	push   $0x80107b29
80104ef9:	56                   	push   %esi
80104efa:	e8 c1 d0 ff ff       	call   80101fc0 <dirlink>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	85 c0                	test   %eax,%eax
80104f04:	78 18                	js     80104f1e <create+0x14e>
80104f06:	83 ec 04             	sub    $0x4,%esp
80104f09:	ff 73 04             	push   0x4(%ebx)
80104f0c:	68 28 7b 10 80       	push   $0x80107b28
80104f11:	56                   	push   %esi
80104f12:	e8 a9 d0 ff ff       	call   80101fc0 <dirlink>
80104f17:	83 c4 10             	add    $0x10,%esp
80104f1a:	85 c0                	test   %eax,%eax
80104f1c:	79 92                	jns    80104eb0 <create+0xe0>
      panic("create dots");
80104f1e:	83 ec 0c             	sub    $0xc,%esp
80104f21:	68 1c 7b 10 80       	push   $0x80107b1c
80104f26:	e8 55 b4 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104f2b:	83 ec 0c             	sub    $0xc,%esp
80104f2e:	68 2b 7b 10 80       	push   $0x80107b2b
80104f33:	e8 48 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f38:	83 ec 0c             	sub    $0xc,%esp
80104f3b:	68 0d 7b 10 80       	push   $0x80107b0d
80104f40:	e8 3b b4 ff ff       	call   80100380 <panic>
80104f45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f4c:	00 
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi

80104f50 <sys_dup>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f5b:	50                   	push   %eax
80104f5c:	6a 00                	push   $0x0
80104f5e:	e8 bd fc ff ff       	call   80104c20 <argint>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 36                	js     80104fa0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f6e:	77 30                	ja     80104fa0 <sys_dup+0x50>
80104f70:	e8 ab eb ff ff       	call   80103b20 <myproc>
80104f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f7c:	85 f6                	test   %esi,%esi
80104f7e:	74 20                	je     80104fa0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f80:	e8 9b eb ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f85:	31 db                	xor    %ebx,%ebx
80104f87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f8e:	00 
80104f8f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104f90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f94:	85 d2                	test   %edx,%edx
80104f96:	74 18                	je     80104fb0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f98:	83 c3 01             	add    $0x1,%ebx
80104f9b:	83 fb 10             	cmp    $0x10,%ebx
80104f9e:	75 f0                	jne    80104f90 <sys_dup+0x40>
}
80104fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fa3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fa8:	89 d8                	mov    %ebx,%eax
80104faa:	5b                   	pop    %ebx
80104fab:	5e                   	pop    %esi
80104fac:	5d                   	pop    %ebp
80104fad:	c3                   	ret
80104fae:	66 90                	xchg   %ax,%ax
  filedup(f);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fb3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fb7:	56                   	push   %esi
80104fb8:	e8 03 bf ff ff       	call   80100ec0 <filedup>
  return fd;
80104fbd:	83 c4 10             	add    $0x10,%esp
}
80104fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fc3:	89 d8                	mov    %ebx,%eax
80104fc5:	5b                   	pop    %ebx
80104fc6:	5e                   	pop    %esi
80104fc7:	5d                   	pop    %ebp
80104fc8:	c3                   	ret
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <sys_read>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fdb:	53                   	push   %ebx
80104fdc:	6a 00                	push   $0x0
80104fde:	e8 3d fc ff ff       	call   80104c20 <argint>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 5e                	js     80105048 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fee:	77 58                	ja     80105048 <sys_read+0x78>
80104ff0:	e8 2b eb ff ff       	call   80103b20 <myproc>
80104ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ff8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ffc:	85 f6                	test   %esi,%esi
80104ffe:	74 48                	je     80105048 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105000:	83 ec 08             	sub    $0x8,%esp
80105003:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105006:	50                   	push   %eax
80105007:	6a 02                	push   $0x2
80105009:	e8 12 fc ff ff       	call   80104c20 <argint>
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	85 c0                	test   %eax,%eax
80105013:	78 33                	js     80105048 <sys_read+0x78>
80105015:	83 ec 04             	sub    $0x4,%esp
80105018:	ff 75 f0             	push   -0x10(%ebp)
8010501b:	53                   	push   %ebx
8010501c:	6a 01                	push   $0x1
8010501e:	e8 4d fc ff ff       	call   80104c70 <argptr>
80105023:	83 c4 10             	add    $0x10,%esp
80105026:	85 c0                	test   %eax,%eax
80105028:	78 1e                	js     80105048 <sys_read+0x78>
  return fileread(f, p, n);
8010502a:	83 ec 04             	sub    $0x4,%esp
8010502d:	ff 75 f0             	push   -0x10(%ebp)
80105030:	ff 75 f4             	push   -0xc(%ebp)
80105033:	56                   	push   %esi
80105034:	e8 07 c0 ff ff       	call   80101040 <fileread>
80105039:	83 c4 10             	add    $0x10,%esp
}
8010503c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010503f:	5b                   	pop    %ebx
80105040:	5e                   	pop    %esi
80105041:	5d                   	pop    %ebp
80105042:	c3                   	ret
80105043:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504d:	eb ed                	jmp    8010503c <sys_read+0x6c>
8010504f:	90                   	nop

80105050 <sys_write>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105055:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105058:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010505b:	53                   	push   %ebx
8010505c:	6a 00                	push   $0x0
8010505e:	e8 bd fb ff ff       	call   80104c20 <argint>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 5e                	js     801050c8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010506a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010506e:	77 58                	ja     801050c8 <sys_write+0x78>
80105070:	e8 ab ea ff ff       	call   80103b20 <myproc>
80105075:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105078:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010507c:	85 f6                	test   %esi,%esi
8010507e:	74 48                	je     801050c8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105080:	83 ec 08             	sub    $0x8,%esp
80105083:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105086:	50                   	push   %eax
80105087:	6a 02                	push   $0x2
80105089:	e8 92 fb ff ff       	call   80104c20 <argint>
8010508e:	83 c4 10             	add    $0x10,%esp
80105091:	85 c0                	test   %eax,%eax
80105093:	78 33                	js     801050c8 <sys_write+0x78>
80105095:	83 ec 04             	sub    $0x4,%esp
80105098:	ff 75 f0             	push   -0x10(%ebp)
8010509b:	53                   	push   %ebx
8010509c:	6a 01                	push   $0x1
8010509e:	e8 cd fb ff ff       	call   80104c70 <argptr>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 1e                	js     801050c8 <sys_write+0x78>
  return filewrite(f, p, n);
801050aa:	83 ec 04             	sub    $0x4,%esp
801050ad:	ff 75 f0             	push   -0x10(%ebp)
801050b0:	ff 75 f4             	push   -0xc(%ebp)
801050b3:	56                   	push   %esi
801050b4:	e8 17 c0 ff ff       	call   801010d0 <filewrite>
801050b9:	83 c4 10             	add    $0x10,%esp
}
801050bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050bf:	5b                   	pop    %ebx
801050c0:	5e                   	pop    %esi
801050c1:	5d                   	pop    %ebp
801050c2:	c3                   	ret
801050c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801050c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cd:	eb ed                	jmp    801050bc <sys_write+0x6c>
801050cf:	90                   	nop

801050d0 <sys_close>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050db:	50                   	push   %eax
801050dc:	6a 00                	push   $0x0
801050de:	e8 3d fb ff ff       	call   80104c20 <argint>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	78 3e                	js     80105128 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ee:	77 38                	ja     80105128 <sys_close+0x58>
801050f0:	e8 2b ea ff ff       	call   80103b20 <myproc>
801050f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050f8:	8d 5a 08             	lea    0x8(%edx),%ebx
801050fb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801050ff:	85 f6                	test   %esi,%esi
80105101:	74 25                	je     80105128 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105103:	e8 18 ea ff ff       	call   80103b20 <myproc>
  fileclose(f);
80105108:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010510b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105112:	00 
  fileclose(f);
80105113:	56                   	push   %esi
80105114:	e8 f7 bd ff ff       	call   80100f10 <fileclose>
  return 0;
80105119:	83 c4 10             	add    $0x10,%esp
8010511c:	31 c0                	xor    %eax,%eax
}
8010511e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105121:	5b                   	pop    %ebx
80105122:	5e                   	pop    %esi
80105123:	5d                   	pop    %ebp
80105124:	c3                   	ret
80105125:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512d:	eb ef                	jmp    8010511e <sys_close+0x4e>
8010512f:	90                   	nop

80105130 <sys_fstat>:
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105135:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105138:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010513b:	53                   	push   %ebx
8010513c:	6a 00                	push   $0x0
8010513e:	e8 dd fa ff ff       	call   80104c20 <argint>
80105143:	83 c4 10             	add    $0x10,%esp
80105146:	85 c0                	test   %eax,%eax
80105148:	78 46                	js     80105190 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010514a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010514e:	77 40                	ja     80105190 <sys_fstat+0x60>
80105150:	e8 cb e9 ff ff       	call   80103b20 <myproc>
80105155:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105158:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010515c:	85 f6                	test   %esi,%esi
8010515e:	74 30                	je     80105190 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105160:	83 ec 04             	sub    $0x4,%esp
80105163:	6a 14                	push   $0x14
80105165:	53                   	push   %ebx
80105166:	6a 01                	push   $0x1
80105168:	e8 03 fb ff ff       	call   80104c70 <argptr>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	78 1c                	js     80105190 <sys_fstat+0x60>
  return filestat(f, st);
80105174:	83 ec 08             	sub    $0x8,%esp
80105177:	ff 75 f4             	push   -0xc(%ebp)
8010517a:	56                   	push   %esi
8010517b:	e8 70 be ff ff       	call   80100ff0 <filestat>
80105180:	83 c4 10             	add    $0x10,%esp
}
80105183:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105186:	5b                   	pop    %ebx
80105187:	5e                   	pop    %esi
80105188:	5d                   	pop    %ebp
80105189:	c3                   	ret
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105195:	eb ec                	jmp    80105183 <sys_fstat+0x53>
80105197:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010519e:	00 
8010519f:	90                   	nop

801051a0 <sys_link>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051a8:	53                   	push   %ebx
801051a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051ac:	50                   	push   %eax
801051ad:	6a 00                	push   $0x0
801051af:	e8 2c fb ff ff       	call   80104ce0 <argstr>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	0f 88 fb 00 00 00    	js     801052ba <sys_link+0x11a>
801051bf:	83 ec 08             	sub    $0x8,%esp
801051c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051c5:	50                   	push   %eax
801051c6:	6a 01                	push   $0x1
801051c8:	e8 13 fb ff ff       	call   80104ce0 <argstr>
801051cd:	83 c4 10             	add    $0x10,%esp
801051d0:	85 c0                	test   %eax,%eax
801051d2:	0f 88 e2 00 00 00    	js     801052ba <sys_link+0x11a>
  begin_op();
801051d8:	e8 23 dd ff ff       	call   80102f00 <begin_op>
  if((ip = namei(old)) == 0){
801051dd:	83 ec 0c             	sub    $0xc,%esp
801051e0:	ff 75 d4             	push   -0x2c(%ebp)
801051e3:	e8 98 ce ff ff       	call   80102080 <namei>
801051e8:	83 c4 10             	add    $0x10,%esp
801051eb:	89 c3                	mov    %eax,%ebx
801051ed:	85 c0                	test   %eax,%eax
801051ef:	0f 84 df 00 00 00    	je     801052d4 <sys_link+0x134>
  ilock(ip);
801051f5:	83 ec 0c             	sub    $0xc,%esp
801051f8:	50                   	push   %eax
801051f9:	e8 a2 c5 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801051fe:	83 c4 10             	add    $0x10,%esp
80105201:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105206:	0f 84 b5 00 00 00    	je     801052c1 <sys_link+0x121>
  iupdate(ip);
8010520c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010520f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105214:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105217:	53                   	push   %ebx
80105218:	e8 d3 c4 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
8010521d:	89 1c 24             	mov    %ebx,(%esp)
80105220:	e8 5b c6 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105225:	58                   	pop    %eax
80105226:	5a                   	pop    %edx
80105227:	57                   	push   %edi
80105228:	ff 75 d0             	push   -0x30(%ebp)
8010522b:	e8 70 ce ff ff       	call   801020a0 <nameiparent>
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	89 c6                	mov    %eax,%esi
80105235:	85 c0                	test   %eax,%eax
80105237:	74 5b                	je     80105294 <sys_link+0xf4>
  ilock(dp);
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	50                   	push   %eax
8010523d:	e8 5e c5 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105242:	8b 03                	mov    (%ebx),%eax
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	39 06                	cmp    %eax,(%esi)
80105249:	75 3d                	jne    80105288 <sys_link+0xe8>
8010524b:	83 ec 04             	sub    $0x4,%esp
8010524e:	ff 73 04             	push   0x4(%ebx)
80105251:	57                   	push   %edi
80105252:	56                   	push   %esi
80105253:	e8 68 cd ff ff       	call   80101fc0 <dirlink>
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	85 c0                	test   %eax,%eax
8010525d:	78 29                	js     80105288 <sys_link+0xe8>
  iunlockput(dp);
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	56                   	push   %esi
80105263:	e8 c8 c7 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105268:	89 1c 24             	mov    %ebx,(%esp)
8010526b:	e8 60 c6 ff ff       	call   801018d0 <iput>
  end_op();
80105270:	e8 fb dc ff ff       	call   80102f70 <end_op>
  return 0;
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	31 c0                	xor    %eax,%eax
}
8010527a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527d:	5b                   	pop    %ebx
8010527e:	5e                   	pop    %esi
8010527f:	5f                   	pop    %edi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105288:	83 ec 0c             	sub    $0xc,%esp
8010528b:	56                   	push   %esi
8010528c:	e8 9f c7 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105291:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	53                   	push   %ebx
80105298:	e8 03 c5 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010529d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052a2:	89 1c 24             	mov    %ebx,(%esp)
801052a5:	e8 46 c4 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801052aa:	89 1c 24             	mov    %ebx,(%esp)
801052ad:	e8 7e c7 ff ff       	call   80101a30 <iunlockput>
  end_op();
801052b2:	e8 b9 dc ff ff       	call   80102f70 <end_op>
  return -1;
801052b7:	83 c4 10             	add    $0x10,%esp
    return -1;
801052ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052bf:	eb b9                	jmp    8010527a <sys_link+0xda>
    iunlockput(ip);
801052c1:	83 ec 0c             	sub    $0xc,%esp
801052c4:	53                   	push   %ebx
801052c5:	e8 66 c7 ff ff       	call   80101a30 <iunlockput>
    end_op();
801052ca:	e8 a1 dc ff ff       	call   80102f70 <end_op>
    return -1;
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	eb e6                	jmp    801052ba <sys_link+0x11a>
    end_op();
801052d4:	e8 97 dc ff ff       	call   80102f70 <end_op>
    return -1;
801052d9:	eb df                	jmp    801052ba <sys_link+0x11a>
801052db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801052e0 <sys_unlink>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052e8:	53                   	push   %ebx
801052e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052ec:	50                   	push   %eax
801052ed:	6a 00                	push   $0x0
801052ef:	e8 ec f9 ff ff       	call   80104ce0 <argstr>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	0f 88 54 01 00 00    	js     80105453 <sys_unlink+0x173>
  begin_op();
801052ff:	e8 fc db ff ff       	call   80102f00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105304:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105307:	83 ec 08             	sub    $0x8,%esp
8010530a:	53                   	push   %ebx
8010530b:	ff 75 c0             	push   -0x40(%ebp)
8010530e:	e8 8d cd ff ff       	call   801020a0 <nameiparent>
80105313:	83 c4 10             	add    $0x10,%esp
80105316:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105319:	85 c0                	test   %eax,%eax
8010531b:	0f 84 58 01 00 00    	je     80105479 <sys_unlink+0x199>
  ilock(dp);
80105321:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105324:	83 ec 0c             	sub    $0xc,%esp
80105327:	57                   	push   %edi
80105328:	e8 73 c4 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010532d:	58                   	pop    %eax
8010532e:	5a                   	pop    %edx
8010532f:	68 29 7b 10 80       	push   $0x80107b29
80105334:	53                   	push   %ebx
80105335:	e8 96 c9 ff ff       	call   80101cd0 <namecmp>
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	85 c0                	test   %eax,%eax
8010533f:	0f 84 fb 00 00 00    	je     80105440 <sys_unlink+0x160>
80105345:	83 ec 08             	sub    $0x8,%esp
80105348:	68 28 7b 10 80       	push   $0x80107b28
8010534d:	53                   	push   %ebx
8010534e:	e8 7d c9 ff ff       	call   80101cd0 <namecmp>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	0f 84 e2 00 00 00    	je     80105440 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010535e:	83 ec 04             	sub    $0x4,%esp
80105361:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105364:	50                   	push   %eax
80105365:	53                   	push   %ebx
80105366:	57                   	push   %edi
80105367:	e8 84 c9 ff ff       	call   80101cf0 <dirlookup>
8010536c:	83 c4 10             	add    $0x10,%esp
8010536f:	89 c3                	mov    %eax,%ebx
80105371:	85 c0                	test   %eax,%eax
80105373:	0f 84 c7 00 00 00    	je     80105440 <sys_unlink+0x160>
  ilock(ip);
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	50                   	push   %eax
8010537d:	e8 1e c4 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010538a:	0f 8e 0a 01 00 00    	jle    8010549a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105390:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105395:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105398:	74 66                	je     80105400 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010539a:	83 ec 04             	sub    $0x4,%esp
8010539d:	6a 10                	push   $0x10
8010539f:	6a 00                	push   $0x0
801053a1:	57                   	push   %edi
801053a2:	e8 c9 f5 ff ff       	call   80104970 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053a7:	6a 10                	push   $0x10
801053a9:	ff 75 c4             	push   -0x3c(%ebp)
801053ac:	57                   	push   %edi
801053ad:	ff 75 b4             	push   -0x4c(%ebp)
801053b0:	e8 fb c7 ff ff       	call   80101bb0 <writei>
801053b5:	83 c4 20             	add    $0x20,%esp
801053b8:	83 f8 10             	cmp    $0x10,%eax
801053bb:	0f 85 cc 00 00 00    	jne    8010548d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801053c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053c6:	0f 84 94 00 00 00    	je     80105460 <sys_unlink+0x180>
  iunlockput(dp);
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	ff 75 b4             	push   -0x4c(%ebp)
801053d2:	e8 59 c6 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801053d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053dc:	89 1c 24             	mov    %ebx,(%esp)
801053df:	e8 0c c3 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801053e4:	89 1c 24             	mov    %ebx,(%esp)
801053e7:	e8 44 c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
801053ec:	e8 7f db ff ff       	call   80102f70 <end_op>
  return 0;
801053f1:	83 c4 10             	add    $0x10,%esp
801053f4:	31 c0                	xor    %eax,%eax
}
801053f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f9:	5b                   	pop    %ebx
801053fa:	5e                   	pop    %esi
801053fb:	5f                   	pop    %edi
801053fc:	5d                   	pop    %ebp
801053fd:	c3                   	ret
801053fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105400:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105404:	76 94                	jbe    8010539a <sys_unlink+0xba>
80105406:	be 20 00 00 00       	mov    $0x20,%esi
8010540b:	eb 0b                	jmp    80105418 <sys_unlink+0x138>
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
80105410:	83 c6 10             	add    $0x10,%esi
80105413:	3b 73 58             	cmp    0x58(%ebx),%esi
80105416:	73 82                	jae    8010539a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105418:	6a 10                	push   $0x10
8010541a:	56                   	push   %esi
8010541b:	57                   	push   %edi
8010541c:	53                   	push   %ebx
8010541d:	e8 8e c6 ff ff       	call   80101ab0 <readi>
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	83 f8 10             	cmp    $0x10,%eax
80105428:	75 56                	jne    80105480 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010542a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010542f:	74 df                	je     80105410 <sys_unlink+0x130>
    iunlockput(ip);
80105431:	83 ec 0c             	sub    $0xc,%esp
80105434:	53                   	push   %ebx
80105435:	e8 f6 c5 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	ff 75 b4             	push   -0x4c(%ebp)
80105446:	e8 e5 c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010544b:	e8 20 db ff ff       	call   80102f70 <end_op>
  return -1;
80105450:	83 c4 10             	add    $0x10,%esp
    return -1;
80105453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105458:	eb 9c                	jmp    801053f6 <sys_unlink+0x116>
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105460:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105463:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105466:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010546b:	50                   	push   %eax
8010546c:	e8 7f c2 ff ff       	call   801016f0 <iupdate>
80105471:	83 c4 10             	add    $0x10,%esp
80105474:	e9 53 ff ff ff       	jmp    801053cc <sys_unlink+0xec>
    end_op();
80105479:	e8 f2 da ff ff       	call   80102f70 <end_op>
    return -1;
8010547e:	eb d3                	jmp    80105453 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	68 4d 7b 10 80       	push   $0x80107b4d
80105488:	e8 f3 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	68 5f 7b 10 80       	push   $0x80107b5f
80105495:	e8 e6 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010549a:	83 ec 0c             	sub    $0xc,%esp
8010549d:	68 3b 7b 10 80       	push   $0x80107b3b
801054a2:	e8 d9 ae ff ff       	call   80100380 <panic>
801054a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054ae:	00 
801054af:	90                   	nop

801054b0 <sys_open>:

int
sys_open(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	57                   	push   %edi
801054b4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054b8:	53                   	push   %ebx
801054b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054bc:	50                   	push   %eax
801054bd:	6a 00                	push   $0x0
801054bf:	e8 1c f8 ff ff       	call   80104ce0 <argstr>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	0f 88 8e 00 00 00    	js     8010555d <sys_open+0xad>
801054cf:	83 ec 08             	sub    $0x8,%esp
801054d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054d5:	50                   	push   %eax
801054d6:	6a 01                	push   $0x1
801054d8:	e8 43 f7 ff ff       	call   80104c20 <argint>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 79                	js     8010555d <sys_open+0xad>
    return -1;

  begin_op();
801054e4:	e8 17 da ff ff       	call   80102f00 <begin_op>

  if(omode & O_CREATE){
801054e9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054ed:	75 79                	jne    80105568 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054ef:	83 ec 0c             	sub    $0xc,%esp
801054f2:	ff 75 e0             	push   -0x20(%ebp)
801054f5:	e8 86 cb ff ff       	call   80102080 <namei>
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	89 c6                	mov    %eax,%esi
801054ff:	85 c0                	test   %eax,%eax
80105501:	0f 84 7e 00 00 00    	je     80105585 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105507:	83 ec 0c             	sub    $0xc,%esp
8010550a:	50                   	push   %eax
8010550b:	e8 90 c2 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105510:	83 c4 10             	add    $0x10,%esp
80105513:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105518:	0f 84 ba 00 00 00    	je     801055d8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010551e:	e8 2d b9 ff ff       	call   80100e50 <filealloc>
80105523:	89 c7                	mov    %eax,%edi
80105525:	85 c0                	test   %eax,%eax
80105527:	74 23                	je     8010554c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105529:	e8 f2 e5 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010552e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105530:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105534:	85 d2                	test   %edx,%edx
80105536:	74 58                	je     80105590 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105538:	83 c3 01             	add    $0x1,%ebx
8010553b:	83 fb 10             	cmp    $0x10,%ebx
8010553e:	75 f0                	jne    80105530 <sys_open+0x80>
    if(f)
      fileclose(f);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	57                   	push   %edi
80105544:	e8 c7 b9 ff ff       	call   80100f10 <fileclose>
80105549:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010554c:	83 ec 0c             	sub    $0xc,%esp
8010554f:	56                   	push   %esi
80105550:	e8 db c4 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105555:	e8 16 da ff ff       	call   80102f70 <end_op>
    return -1;
8010555a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010555d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105562:	eb 65                	jmp    801055c9 <sys_open+0x119>
80105564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105568:	83 ec 0c             	sub    $0xc,%esp
8010556b:	31 c9                	xor    %ecx,%ecx
8010556d:	ba 02 00 00 00       	mov    $0x2,%edx
80105572:	6a 00                	push   $0x0
80105574:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105577:	e8 54 f8 ff ff       	call   80104dd0 <create>
    if(ip == 0){
8010557c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010557f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105581:	85 c0                	test   %eax,%eax
80105583:	75 99                	jne    8010551e <sys_open+0x6e>
      end_op();
80105585:	e8 e6 d9 ff ff       	call   80102f70 <end_op>
      return -1;
8010558a:	eb d1                	jmp    8010555d <sys_open+0xad>
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105590:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105593:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105597:	56                   	push   %esi
80105598:	e8 e3 c2 ff ff       	call   80101880 <iunlock>
  end_op();
8010559d:	e8 ce d9 ff ff       	call   80102f70 <end_op>

  f->type = FD_INODE;
801055a2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055ab:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055ae:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055b1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055b3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055ba:	f7 d0                	not    %eax
801055bc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055bf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055c2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055c5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055cc:	89 d8                	mov    %ebx,%eax
801055ce:	5b                   	pop    %ebx
801055cf:	5e                   	pop    %esi
801055d0:	5f                   	pop    %edi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret
801055d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055db:	85 c9                	test   %ecx,%ecx
801055dd:	0f 84 3b ff ff ff    	je     8010551e <sys_open+0x6e>
801055e3:	e9 64 ff ff ff       	jmp    8010554c <sys_open+0x9c>
801055e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055ef:	00 

801055f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055f6:	e8 05 d9 ff ff       	call   80102f00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055fb:	83 ec 08             	sub    $0x8,%esp
801055fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105601:	50                   	push   %eax
80105602:	6a 00                	push   $0x0
80105604:	e8 d7 f6 ff ff       	call   80104ce0 <argstr>
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	85 c0                	test   %eax,%eax
8010560e:	78 30                	js     80105640 <sys_mkdir+0x50>
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105616:	31 c9                	xor    %ecx,%ecx
80105618:	ba 01 00 00 00       	mov    $0x1,%edx
8010561d:	6a 00                	push   $0x0
8010561f:	e8 ac f7 ff ff       	call   80104dd0 <create>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	74 15                	je     80105640 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562b:	83 ec 0c             	sub    $0xc,%esp
8010562e:	50                   	push   %eax
8010562f:	e8 fc c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105634:	e8 37 d9 ff ff       	call   80102f70 <end_op>
  return 0;
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	31 c0                	xor    %eax,%eax
}
8010563e:	c9                   	leave
8010563f:	c3                   	ret
    end_op();
80105640:	e8 2b d9 ff ff       	call   80102f70 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave
8010564b:	c3                   	ret
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_mknod>:

int
sys_mknod(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105656:	e8 a5 d8 ff ff       	call   80102f00 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010565b:	83 ec 08             	sub    $0x8,%esp
8010565e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105661:	50                   	push   %eax
80105662:	6a 00                	push   $0x0
80105664:	e8 77 f6 ff ff       	call   80104ce0 <argstr>
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	85 c0                	test   %eax,%eax
8010566e:	78 60                	js     801056d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105676:	50                   	push   %eax
80105677:	6a 01                	push   $0x1
80105679:	e8 a2 f5 ff ff       	call   80104c20 <argint>
  if((argstr(0, &path)) < 0 ||
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	85 c0                	test   %eax,%eax
80105683:	78 4b                	js     801056d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105685:	83 ec 08             	sub    $0x8,%esp
80105688:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568b:	50                   	push   %eax
8010568c:	6a 02                	push   $0x2
8010568e:	e8 8d f5 ff ff       	call   80104c20 <argint>
     argint(1, &major) < 0 ||
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	78 36                	js     801056d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010569a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010569e:	83 ec 0c             	sub    $0xc,%esp
801056a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056a5:	ba 03 00 00 00       	mov    $0x3,%edx
801056aa:	50                   	push   %eax
801056ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ae:	e8 1d f7 ff ff       	call   80104dd0 <create>
     argint(2, &minor) < 0 ||
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	74 16                	je     801056d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	50                   	push   %eax
801056be:	e8 6d c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
801056c3:	e8 a8 d8 ff ff       	call   80102f70 <end_op>
  return 0;
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	31 c0                	xor    %eax,%eax
}
801056cd:	c9                   	leave
801056ce:	c3                   	ret
801056cf:	90                   	nop
    end_op();
801056d0:	e8 9b d8 ff ff       	call   80102f70 <end_op>
    return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056da:	c9                   	leave
801056db:	c3                   	ret
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_chdir>:

int
sys_chdir(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	56                   	push   %esi
801056e4:	53                   	push   %ebx
801056e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056e8:	e8 33 e4 ff ff       	call   80103b20 <myproc>
801056ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056ef:	e8 0c d8 ff ff       	call   80102f00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056f4:	83 ec 08             	sub    $0x8,%esp
801056f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056fa:	50                   	push   %eax
801056fb:	6a 00                	push   $0x0
801056fd:	e8 de f5 ff ff       	call   80104ce0 <argstr>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	85 c0                	test   %eax,%eax
80105707:	78 77                	js     80105780 <sys_chdir+0xa0>
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	ff 75 f4             	push   -0xc(%ebp)
8010570f:	e8 6c c9 ff ff       	call   80102080 <namei>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	89 c3                	mov    %eax,%ebx
80105719:	85 c0                	test   %eax,%eax
8010571b:	74 63                	je     80105780 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	50                   	push   %eax
80105721:	e8 7a c0 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010572e:	75 30                	jne    80105760 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	53                   	push   %ebx
80105734:	e8 47 c1 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105739:	58                   	pop    %eax
8010573a:	ff 76 68             	push   0x68(%esi)
8010573d:	e8 8e c1 ff ff       	call   801018d0 <iput>
  end_op();
80105742:	e8 29 d8 ff ff       	call   80102f70 <end_op>
  curproc->cwd = ip;
80105747:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	31 c0                	xor    %eax,%eax
}
8010574f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105752:	5b                   	pop    %ebx
80105753:	5e                   	pop    %esi
80105754:	5d                   	pop    %ebp
80105755:	c3                   	ret
80105756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010575d:	00 
8010575e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 c7 c2 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105769:	e8 02 d8 ff ff       	call   80102f70 <end_op>
    return -1;
8010576e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105776:	eb d7                	jmp    8010574f <sys_chdir+0x6f>
80105778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010577f:	00 
    end_op();
80105780:	e8 eb d7 ff ff       	call   80102f70 <end_op>
    return -1;
80105785:	eb ea                	jmp    80105771 <sys_chdir+0x91>
80105787:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010578e:	00 
8010578f:	90                   	nop

80105790 <sys_exec>:

int
sys_exec(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105795:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010579b:	53                   	push   %ebx
8010579c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057a2:	50                   	push   %eax
801057a3:	6a 00                	push   $0x0
801057a5:	e8 36 f5 ff ff       	call   80104ce0 <argstr>
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	85 c0                	test   %eax,%eax
801057af:	0f 88 87 00 00 00    	js     8010583c <sys_exec+0xac>
801057b5:	83 ec 08             	sub    $0x8,%esp
801057b8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057be:	50                   	push   %eax
801057bf:	6a 01                	push   $0x1
801057c1:	e8 5a f4 ff ff       	call   80104c20 <argint>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	78 6f                	js     8010583c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057cd:	83 ec 04             	sub    $0x4,%esp
801057d0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801057d6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057d8:	68 80 00 00 00       	push   $0x80
801057dd:	6a 00                	push   $0x0
801057df:	56                   	push   %esi
801057e0:	e8 8b f1 ff ff       	call   80104970 <memset>
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ef:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057f9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105800:	50                   	push   %eax
80105801:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105807:	01 f8                	add    %edi,%eax
80105809:	50                   	push   %eax
8010580a:	e8 81 f3 ff ff       	call   80104b90 <fetchint>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 c0                	test   %eax,%eax
80105814:	78 26                	js     8010583c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105816:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010581c:	85 c0                	test   %eax,%eax
8010581e:	74 30                	je     80105850 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105826:	52                   	push   %edx
80105827:	50                   	push   %eax
80105828:	e8 a3 f3 ff ff       	call   80104bd0 <fetchstr>
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	85 c0                	test   %eax,%eax
80105832:	78 08                	js     8010583c <sys_exec+0xac>
  for(i=0;; i++){
80105834:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105837:	83 fb 20             	cmp    $0x20,%ebx
8010583a:	75 b4                	jne    801057f0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010583c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010583f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105844:	5b                   	pop    %ebx
80105845:	5e                   	pop    %esi
80105846:	5f                   	pop    %edi
80105847:	5d                   	pop    %ebp
80105848:	c3                   	ret
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105850:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105857:	00 00 00 00 
  return exec(path, argv);
8010585b:	83 ec 08             	sub    $0x8,%esp
8010585e:	56                   	push   %esi
8010585f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105865:	e8 46 b2 ff ff       	call   80100ab0 <exec>
8010586a:	83 c4 10             	add    $0x10,%esp
}
8010586d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105870:	5b                   	pop    %ebx
80105871:	5e                   	pop    %esi
80105872:	5f                   	pop    %edi
80105873:	5d                   	pop    %ebp
80105874:	c3                   	ret
80105875:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587c:	00 
8010587d:	8d 76 00             	lea    0x0(%esi),%esi

80105880 <sys_pipe>:

int
sys_pipe(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105885:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105888:	53                   	push   %ebx
80105889:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010588c:	6a 08                	push   $0x8
8010588e:	50                   	push   %eax
8010588f:	6a 00                	push   $0x0
80105891:	e8 da f3 ff ff       	call   80104c70 <argptr>
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	85 c0                	test   %eax,%eax
8010589b:	0f 88 8b 00 00 00    	js     8010592c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058a1:	83 ec 08             	sub    $0x8,%esp
801058a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058a7:	50                   	push   %eax
801058a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058ab:	50                   	push   %eax
801058ac:	e8 1f dd ff ff       	call   801035d0 <pipealloc>
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	85 c0                	test   %eax,%eax
801058b6:	78 74                	js     8010592c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058bb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058bd:	e8 5e e2 ff ff       	call   80103b20 <myproc>
    if(curproc->ofile[fd] == 0){
801058c2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058c6:	85 f6                	test   %esi,%esi
801058c8:	74 16                	je     801058e0 <sys_pipe+0x60>
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058d0:	83 c3 01             	add    $0x1,%ebx
801058d3:	83 fb 10             	cmp    $0x10,%ebx
801058d6:	74 3d                	je     80105915 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801058d8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058dc:	85 f6                	test   %esi,%esi
801058de:	75 f0                	jne    801058d0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058e0:	8d 73 08             	lea    0x8(%ebx),%esi
801058e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ea:	e8 31 e2 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ef:	31 d2                	xor    %edx,%edx
801058f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058fc:	85 c9                	test   %ecx,%ecx
801058fe:	74 38                	je     80105938 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105900:	83 c2 01             	add    $0x1,%edx
80105903:	83 fa 10             	cmp    $0x10,%edx
80105906:	75 f0                	jne    801058f8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105908:	e8 13 e2 ff ff       	call   80103b20 <myproc>
8010590d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105914:	00 
    fileclose(rf);
80105915:	83 ec 0c             	sub    $0xc,%esp
80105918:	ff 75 e0             	push   -0x20(%ebp)
8010591b:	e8 f0 b5 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105920:	58                   	pop    %eax
80105921:	ff 75 e4             	push   -0x1c(%ebp)
80105924:	e8 e7 b5 ff ff       	call   80100f10 <fileclose>
    return -1;
80105929:	83 c4 10             	add    $0x10,%esp
    return -1;
8010592c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105931:	eb 16                	jmp    80105949 <sys_pipe+0xc9>
80105933:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105938:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010593c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010593f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105941:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105944:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105947:	31 c0                	xor    %eax,%eax
}
80105949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010594c:	5b                   	pop    %ebx
8010594d:	5e                   	pop    %esi
8010594e:	5f                   	pop    %edi
8010594f:	5d                   	pop    %ebp
80105950:	c3                   	ret
80105951:	66 90                	xchg   %ax,%ax
80105953:	66 90                	xchg   %ax,%ax
80105955:	66 90                	xchg   %ax,%ax
80105957:	66 90                	xchg   %ax,%ax
80105959:	66 90                	xchg   %ax,%ax
8010595b:	66 90                	xchg   %ax,%ax
8010595d:	66 90                	xchg   %ax,%ax
8010595f:	90                   	nop

80105960 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105960:	e9 5b e3 ff ff       	jmp    80103cc0 <fork>
80105965:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010596c:	00 
8010596d:	8d 76 00             	lea    0x0(%esi),%esi

80105970 <sys_exit>:
}

int
sys_exit(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 08             	sub    $0x8,%esp
  exit();
80105976:	e8 c5 e6 ff ff       	call   80104040 <exit>
  return 0;  // not reached
}
8010597b:	31 c0                	xor    %eax,%eax
8010597d:	c9                   	leave
8010597e:	c3                   	ret
8010597f:	90                   	nop

80105980 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105980:	e9 eb e7 ff ff       	jmp    80104170 <wait>
80105985:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010598c:	00 
8010598d:	8d 76 00             	lea    0x0(%esi),%esi

80105990 <sys_kill>:
}

int
sys_kill(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105999:	50                   	push   %eax
8010599a:	6a 00                	push   $0x0
8010599c:	e8 7f f2 ff ff       	call   80104c20 <argint>
801059a1:	83 c4 10             	add    $0x10,%esp
801059a4:	85 c0                	test   %eax,%eax
801059a6:	78 18                	js     801059c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	ff 75 f4             	push   -0xc(%ebp)
801059ae:	e8 5d ea ff ff       	call   80104410 <kill>
801059b3:	83 c4 10             	add    $0x10,%esp
}
801059b6:	c9                   	leave
801059b7:	c3                   	ret
801059b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059bf:	00 
801059c0:	c9                   	leave
    return -1;
801059c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c6:	c3                   	ret
801059c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ce:	00 
801059cf:	90                   	nop

801059d0 <sys_getpid>:

int
sys_getpid(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059d6:	e8 45 e1 ff ff       	call   80103b20 <myproc>
801059db:	8b 40 10             	mov    0x10(%eax),%eax
}
801059de:	c9                   	leave
801059df:	c3                   	ret

801059e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 2e f2 ff ff       	call   80104c20 <argint>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 27                	js     80105a20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059f9:	e8 22 e1 ff ff       	call   80103b20 <myproc>
  if(growproc(n) < 0)
801059fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a01:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a03:	ff 75 f4             	push   -0xc(%ebp)
80105a06:	e8 35 e2 ff ff       	call   80103c40 <growproc>
80105a0b:	83 c4 10             	add    $0x10,%esp
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	78 0e                	js     80105a20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a12:	89 d8                	mov    %ebx,%eax
80105a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a17:	c9                   	leave
80105a18:	c3                   	ret
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a25:	eb eb                	jmp    80105a12 <sys_sbrk+0x32>
80105a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a2e:	00 
80105a2f:	90                   	nop

80105a30 <sys_sleep>:

int
sys_sleep(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a3a:	50                   	push   %eax
80105a3b:	6a 00                	push   $0x0
80105a3d:	e8 de f1 ff ff       	call   80104c20 <argint>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	78 64                	js     80105aad <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105a49:	83 ec 0c             	sub    $0xc,%esp
80105a4c:	68 80 2c 12 80       	push   $0x80122c80
80105a51:	e8 1a ee ff ff       	call   80104870 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a59:	8b 1d 60 2c 12 80    	mov    0x80122c60,%ebx
  while(ticks - ticks0 < n){
80105a5f:	83 c4 10             	add    $0x10,%esp
80105a62:	85 d2                	test   %edx,%edx
80105a64:	75 2b                	jne    80105a91 <sys_sleep+0x61>
80105a66:	eb 58                	jmp    80105ac0 <sys_sleep+0x90>
80105a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a70:	83 ec 08             	sub    $0x8,%esp
80105a73:	68 80 2c 12 80       	push   $0x80122c80
80105a78:	68 60 2c 12 80       	push   $0x80122c60
80105a7d:	e8 6e e8 ff ff       	call   801042f0 <sleep>
  while(ticks - ticks0 < n){
80105a82:	a1 60 2c 12 80       	mov    0x80122c60,%eax
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	29 d8                	sub    %ebx,%eax
80105a8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a8f:	73 2f                	jae    80105ac0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a91:	e8 8a e0 ff ff       	call   80103b20 <myproc>
80105a96:	8b 40 24             	mov    0x24(%eax),%eax
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	74 d3                	je     80105a70 <sys_sleep+0x40>
      release(&tickslock);
80105a9d:	83 ec 0c             	sub    $0xc,%esp
80105aa0:	68 80 2c 12 80       	push   $0x80122c80
80105aa5:	e8 66 ed ff ff       	call   80104810 <release>
      return -1;
80105aaa:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab5:	c9                   	leave
80105ab6:	c3                   	ret
80105ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105abe:	00 
80105abf:	90                   	nop
  release(&tickslock);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	68 80 2c 12 80       	push   $0x80122c80
80105ac8:	e8 43 ed ff ff       	call   80104810 <release>
}
80105acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105ad0:	83 c4 10             	add    $0x10,%esp
80105ad3:	31 c0                	xor    %eax,%eax
}
80105ad5:	c9                   	leave
80105ad6:	c3                   	ret
80105ad7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ade:	00 
80105adf:	90                   	nop

80105ae0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	53                   	push   %ebx
80105ae4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ae7:	68 80 2c 12 80       	push   $0x80122c80
80105aec:	e8 7f ed ff ff       	call   80104870 <acquire>
  xticks = ticks;
80105af1:	8b 1d 60 2c 12 80    	mov    0x80122c60,%ebx
  release(&tickslock);
80105af7:	c7 04 24 80 2c 12 80 	movl   $0x80122c80,(%esp)
80105afe:	e8 0d ed ff ff       	call   80104810 <release>
  return xticks;
}
80105b03:	89 d8                	mov    %ebx,%eax
80105b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b08:	c9                   	leave
80105b09:	c3                   	ret
80105b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b10 <sys_mycall>:

int sys_mycall(void) {
return 1;
}
80105b10:	b8 01 00 00 00       	mov    $0x1,%eax
80105b15:	c3                   	ret
80105b16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b1d:	00 
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <sys_date>:

int
sys_date(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 1c             	sub    $0x1c,%esp
    struct rtcdate *r;

    // pega o ponteiro do espaço do usuário
    if (argptr(0, (void *)&r, sizeof(*r)) < 0)
80105b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b29:	6a 18                	push   $0x18
80105b2b:	50                   	push   %eax
80105b2c:	6a 00                	push   $0x0
80105b2e:	e8 3d f1 ff ff       	call   80104c70 <argptr>
80105b33:	83 c4 10             	add    $0x10,%esp
80105b36:	85 c0                	test   %eax,%eax
80105b38:	78 16                	js     80105b50 <sys_date+0x30>
        return -1;

    // preenche a struct usando o RTC
    cmostime(r);
80105b3a:	83 ec 0c             	sub    $0xc,%esp
80105b3d:	ff 75 f4             	push   -0xc(%ebp)
80105b40:	e8 2b d0 ff ff       	call   80102b70 <cmostime>

    return 0;
80105b45:	83 c4 10             	add    $0x10,%esp
80105b48:	31 c0                	xor    %eax,%eax
}
80105b4a:	c9                   	leave
80105b4b:	c3                   	ret
80105b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b50:	c9                   	leave
        return -1;
80105b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b56:	c3                   	ret
80105b57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b5e:	00 
80105b5f:	90                   	nop

80105b60 <sys_cowfork>:


int
sys_cowfork(void)
{
  return cowfork();
80105b60:	e9 6b e2 ff ff       	jmp    80103dd0 <cowfork>

80105b65 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b65:	1e                   	push   %ds
  pushl %es
80105b66:	06                   	push   %es
  pushl %fs
80105b67:	0f a0                	push   %fs
  pushl %gs
80105b69:	0f a8                	push   %gs
  pushal
80105b6b:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b6c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b70:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b72:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b74:	54                   	push   %esp
  call trap
80105b75:	e8 c6 00 00 00       	call   80105c40 <trap>
  addl $4, %esp
80105b7a:	83 c4 04             	add    $0x4,%esp

80105b7d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b7d:	61                   	popa
  popl %gs
80105b7e:	0f a9                	pop    %gs
  popl %fs
80105b80:	0f a1                	pop    %fs
  popl %es
80105b82:	07                   	pop    %es
  popl %ds
80105b83:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b84:	83 c4 08             	add    $0x8,%esp
  iret
80105b87:	cf                   	iret
80105b88:	66 90                	xchg   %ax,%ax
80105b8a:	66 90                	xchg   %ax,%ax
80105b8c:	66 90                	xchg   %ax,%ax
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b91:	31 c0                	xor    %eax,%eax
{
80105b93:	89 e5                	mov    %esp,%ebp
80105b95:	83 ec 08             	sub    $0x8,%esp
80105b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ba0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ba7:	c7 04 c5 c2 2c 12 80 	movl   $0x8e000008,-0x7fedd33e(,%eax,8)
80105bae:	08 00 00 8e 
80105bb2:	66 89 14 c5 c0 2c 12 	mov    %dx,-0x7fedd340(,%eax,8)
80105bb9:	80 
80105bba:	c1 ea 10             	shr    $0x10,%edx
80105bbd:	66 89 14 c5 c6 2c 12 	mov    %dx,-0x7fedd33a(,%eax,8)
80105bc4:	80 
  for(i = 0; i < 256; i++)
80105bc5:	83 c0 01             	add    $0x1,%eax
80105bc8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bcd:	75 d1                	jne    80105ba0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bcf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bd2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105bd7:	c7 05 c2 2e 12 80 08 	movl   $0xef000008,0x80122ec2
80105bde:	00 00 ef 
  initlock(&tickslock, "time");
80105be1:	68 6e 7b 10 80       	push   $0x80107b6e
80105be6:	68 80 2c 12 80       	push   $0x80122c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105beb:	66 a3 c0 2e 12 80    	mov    %ax,0x80122ec0
80105bf1:	c1 e8 10             	shr    $0x10,%eax
80105bf4:	66 a3 c6 2e 12 80    	mov    %ax,0x80122ec6
  initlock(&tickslock, "time");
80105bfa:	e8 81 ea ff ff       	call   80104680 <initlock>
}
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	c9                   	leave
80105c03:	c3                   	ret
80105c04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c0b:	00 
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <idtinit>:

void
idtinit(void)
{
80105c10:	55                   	push   %ebp
  pd[0] = size-1;
80105c11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c16:	89 e5                	mov    %esp,%ebp
80105c18:	83 ec 10             	sub    $0x10,%esp
80105c1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c1f:	b8 c0 2c 12 80       	mov    $0x80122cc0,%eax
80105c24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c28:	c1 e8 10             	shr    $0x10,%eax
80105c2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c35:	c9                   	leave
80105c36:	c3                   	ret
80105c37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c3e:	00 
80105c3f:	90                   	nop

80105c40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	57                   	push   %edi
80105c44:	56                   	push   %esi
80105c45:	53                   	push   %ebx
80105c46:	83 ec 1c             	sub    $0x1c,%esp
80105c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c4c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c4f:	83 f8 40             	cmp    $0x40,%eax
80105c52:	0f 84 30 01 00 00    	je     80105d88 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c58:	83 e8 0e             	sub    $0xe,%eax
80105c5b:	83 f8 31             	cmp    $0x31,%eax
80105c5e:	0f 87 8c 00 00 00    	ja     80105cf0 <trap+0xb0>
80105c64:	ff 24 85 64 81 10 80 	jmp    *-0x7fef7e9c(,%eax,4)
80105c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105c70:	e8 8b de ff ff       	call   80103b00 <cpuid>
80105c75:	85 c0                	test   %eax,%eax
80105c77:	0f 84 8b 02 00 00    	je     80105f08 <trap+0x2c8>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105c7d:	e8 2e ce ff ff       	call   80102ab0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c82:	e8 99 de ff ff       	call   80103b20 <myproc>
80105c87:	85 c0                	test   %eax,%eax
80105c89:	74 1a                	je     80105ca5 <trap+0x65>
80105c8b:	e8 90 de ff ff       	call   80103b20 <myproc>
80105c90:	8b 50 24             	mov    0x24(%eax),%edx
80105c93:	85 d2                	test   %edx,%edx
80105c95:	74 0e                	je     80105ca5 <trap+0x65>
80105c97:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c9b:	f7 d0                	not    %eax
80105c9d:	a8 03                	test   $0x3,%al
80105c9f:	0f 84 43 02 00 00    	je     80105ee8 <trap+0x2a8>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ca5:	e8 76 de ff ff       	call   80103b20 <myproc>
80105caa:	85 c0                	test   %eax,%eax
80105cac:	74 0f                	je     80105cbd <trap+0x7d>
80105cae:	e8 6d de ff ff       	call   80103b20 <myproc>
80105cb3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cb7:	0f 84 b3 00 00 00    	je     80105d70 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cbd:	e8 5e de ff ff       	call   80103b20 <myproc>
80105cc2:	85 c0                	test   %eax,%eax
80105cc4:	74 1a                	je     80105ce0 <trap+0xa0>
80105cc6:	e8 55 de ff ff       	call   80103b20 <myproc>
80105ccb:	8b 40 24             	mov    0x24(%eax),%eax
80105cce:	85 c0                	test   %eax,%eax
80105cd0:	74 0e                	je     80105ce0 <trap+0xa0>
80105cd2:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cd6:	f7 d0                	not    %eax
80105cd8:	a8 03                	test   $0x3,%al
80105cda:	0f 84 d5 00 00 00    	je     80105db5 <trap+0x175>
    exit();
}
80105ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ce3:	5b                   	pop    %ebx
80105ce4:	5e                   	pop    %esi
80105ce5:	5f                   	pop    %edi
80105ce6:	5d                   	pop    %ebp
80105ce7:	c3                   	ret
80105ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cef:	00 
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cf0:	e8 2b de ff ff       	call   80103b20 <myproc>
80105cf5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cf8:	85 c0                	test   %eax,%eax
80105cfa:	0f 84 c6 02 00 00    	je     80105fc6 <trap+0x386>
80105d00:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d04:	0f 84 bc 02 00 00    	je     80105fc6 <trap+0x386>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d0a:	0f 20 d1             	mov    %cr2,%ecx
80105d0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d10:	e8 eb dd ff ff       	call   80103b00 <cpuid>
80105d15:	8b 73 30             	mov    0x30(%ebx),%esi
80105d18:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d1b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d21:	e8 fa dd ff ff       	call   80103b20 <myproc>
80105d26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d29:	e8 f2 dd ff ff       	call   80103b20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d2e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d31:	51                   	push   %ecx
80105d32:	57                   	push   %edi
80105d33:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d36:	52                   	push   %edx
80105d37:	ff 75 e4             	push   -0x1c(%ebp)
80105d3a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d3b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d3e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d41:	56                   	push   %esi
80105d42:	ff 70 10             	push   0x10(%eax)
80105d45:	68 44 7e 10 80       	push   $0x80107e44
80105d4a:	e8 61 a9 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105d4f:	83 c4 20             	add    $0x20,%esp
80105d52:	e8 c9 dd ff ff       	call   80103b20 <myproc>
80105d57:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d5e:	e8 bd dd ff ff       	call   80103b20 <myproc>
80105d63:	85 c0                	test   %eax,%eax
80105d65:	0f 85 20 ff ff ff    	jne    80105c8b <trap+0x4b>
80105d6b:	e9 35 ff ff ff       	jmp    80105ca5 <trap+0x65>
  if(myproc() && myproc()->state == RUNNING &&
80105d70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d74:	0f 85 43 ff ff ff    	jne    80105cbd <trap+0x7d>
    yield();
80105d7a:	e8 21 e5 ff ff       	call   801042a0 <yield>
80105d7f:	e9 39 ff ff ff       	jmp    80105cbd <trap+0x7d>
80105d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d88:	e8 93 dd ff ff       	call   80103b20 <myproc>
80105d8d:	8b 70 24             	mov    0x24(%eax),%esi
80105d90:	85 f6                	test   %esi,%esi
80105d92:	0f 85 60 01 00 00    	jne    80105ef8 <trap+0x2b8>
    myproc()->tf = tf;
80105d98:	e8 83 dd ff ff       	call   80103b20 <myproc>
80105d9d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105da0:	e8 bb ef ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80105da5:	e8 76 dd ff ff       	call   80103b20 <myproc>
80105daa:	8b 48 24             	mov    0x24(%eax),%ecx
80105dad:	85 c9                	test   %ecx,%ecx
80105daf:	0f 84 2b ff ff ff    	je     80105ce0 <trap+0xa0>
}
80105db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db8:	5b                   	pop    %ebx
80105db9:	5e                   	pop    %esi
80105dba:	5f                   	pop    %edi
80105dbb:	5d                   	pop    %ebp
      exit();
80105dbc:	e9 7f e2 ff ff       	jmp    80104040 <exit>
80105dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105dc8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105dcb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105dcf:	e8 2c dd ff ff       	call   80103b00 <cpuid>
80105dd4:	57                   	push   %edi
80105dd5:	56                   	push   %esi
80105dd6:	50                   	push   %eax
80105dd7:	68 ec 7d 10 80       	push   $0x80107dec
80105ddc:	e8 cf a8 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105de1:	e8 ca cc ff ff       	call   80102ab0 <lapiceoi>
    break;
80105de6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105de9:	e8 32 dd ff ff       	call   80103b20 <myproc>
80105dee:	85 c0                	test   %eax,%eax
80105df0:	0f 85 95 fe ff ff    	jne    80105c8b <trap+0x4b>
80105df6:	e9 aa fe ff ff       	jmp    80105ca5 <trap+0x65>
80105dfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e00:	e8 7b cb ff ff       	call   80102980 <kbdintr>
    lapiceoi();
80105e05:	e8 a6 cc ff ff       	call   80102ab0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0a:	e8 11 dd ff ff       	call   80103b20 <myproc>
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	0f 85 74 fe ff ff    	jne    80105c8b <trap+0x4b>
80105e17:	e9 89 fe ff ff       	jmp    80105ca5 <trap+0x65>
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e20:	e8 4b 03 00 00       	call   80106170 <uartintr>
    lapiceoi();
80105e25:	e8 86 cc ff ff       	call   80102ab0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e2a:	e8 f1 dc ff ff       	call   80103b20 <myproc>
80105e2f:	85 c0                	test   %eax,%eax
80105e31:	0f 85 54 fe ff ff    	jne    80105c8b <trap+0x4b>
80105e37:	e9 69 fe ff ff       	jmp    80105ca5 <trap+0x65>
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e40:	e8 eb c3 ff ff       	call   80102230 <ideintr>
80105e45:	e9 33 fe ff ff       	jmp    80105c7d <trap+0x3d>
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e50:	0f 20 d6             	mov    %cr2,%esi
      if(va >= KERNBASE || (pte = walkpgdir(myproc()->pgdir, (void*)va, 0)) == 0 || !(*pte & PTE_P) || !(*pte & PTE_U)) {
80105e53:	85 f6                	test   %esi,%esi
80105e55:	78 69                	js     80105ec0 <trap+0x280>
80105e57:	e8 c4 dc ff ff       	call   80103b20 <myproc>
80105e5c:	83 ec 04             	sub    $0x4,%esp
80105e5f:	6a 00                	push   $0x0
80105e61:	56                   	push   %esi
80105e62:	ff 70 04             	push   0x4(%eax)
80105e65:	e8 d6 0f 00 00       	call   80106e40 <walkpgdir>
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	89 c6                	mov    %eax,%esi
80105e6f:	85 c0                	test   %eax,%eax
80105e71:	74 4d                	je     80105ec0 <trap+0x280>
80105e73:	8b 00                	mov    (%eax),%eax
80105e75:	89 c2                	mov    %eax,%edx
80105e77:	f7 d2                	not    %edx
80105e79:	83 e2 05             	and    $0x5,%edx
80105e7c:	75 42                	jne    80105ec0 <trap+0x280>
      if(*pte & PTE_COW) {
80105e7e:	f6 c4 01             	test   $0x1,%ah
80105e81:	0f 84 b5 00 00 00    	je     80105f3c <trap+0x2fc>
          pa = PTE_ADDR(*pte);
80105e87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          if(get_ref(pa) == 1) {
80105e8c:	83 ec 0c             	sub    $0xc,%esp
80105e8f:	50                   	push   %eax
          pa = PTE_ADDR(*pte);
80105e90:	89 c7                	mov    %eax,%edi
          if(get_ref(pa) == 1) {
80105e92:	e8 b9 c9 ff ff       	call   80102850 <get_ref>
80105e97:	83 c4 10             	add    $0x10,%esp
80105e9a:	83 f8 01             	cmp    $0x1,%eax
80105e9d:	0f 85 ba 00 00 00    	jne    80105f5d <trap+0x31d>
              *pte &= ~PTE_COW;
80105ea3:	8b 06                	mov    (%esi),%eax
80105ea5:	80 e4 fe             	and    $0xfe,%ah
80105ea8:	83 c8 02             	or     $0x2,%eax
80105eab:	89 06                	mov    %eax,(%esi)
          asm volatile("movl %%cr3, %0" : "=r" (cr3_val));
80105ead:	0f 20 d8             	mov    %cr3,%eax
          asm volatile("movl %0, %%cr3" :: "r" (cr3_val));
80105eb0:	0f 22 d8             	mov    %eax,%cr3
          break; // Falha tratada com sucesso
80105eb3:	e9 ca fd ff ff       	jmp    80105c82 <trap+0x42>
80105eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ebf:	00 
          cprintf("Segmentation Fault\n");
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	68 73 7b 10 80       	push   $0x80107b73
80105ec8:	e8 e3 a7 ff ff       	call   801006b0 <cprintf>
          myproc()->killed = 1;
80105ecd:	e8 4e dc ff ff       	call   80103b20 <myproc>
          break;
80105ed2:	83 c4 10             	add    $0x10,%esp
          myproc()->killed = 1;
80105ed5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          break;
80105edc:	e9 a1 fd ff ff       	jmp    80105c82 <trap+0x42>
80105ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ee8:	e8 53 e1 ff ff       	call   80104040 <exit>
80105eed:	e9 b3 fd ff ff       	jmp    80105ca5 <trap+0x65>
80105ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ef8:	e8 43 e1 ff ff       	call   80104040 <exit>
80105efd:	e9 96 fe ff ff       	jmp    80105d98 <trap+0x158>
80105f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f08:	83 ec 0c             	sub    $0xc,%esp
80105f0b:	68 80 2c 12 80       	push   $0x80122c80
80105f10:	e8 5b e9 ff ff       	call   80104870 <acquire>
      ticks++;
80105f15:	83 05 60 2c 12 80 01 	addl   $0x1,0x80122c60
      wakeup(&ticks);
80105f1c:	c7 04 24 60 2c 12 80 	movl   $0x80122c60,(%esp)
80105f23:	e8 88 e4 ff ff       	call   801043b0 <wakeup>
      release(&tickslock);
80105f28:	c7 04 24 80 2c 12 80 	movl   $0x80122c80,(%esp)
80105f2f:	e8 dc e8 ff ff       	call   80104810 <release>
80105f34:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f37:	e9 41 fd ff ff       	jmp    80105c7d <trap+0x3d>
      cprintf("Page fault legítimo (não COW)\n");
80105f3c:	83 ec 0c             	sub    $0xc,%esp
80105f3f:	68 c8 7d 10 80       	push   $0x80107dc8
80105f44:	e8 67 a7 ff ff       	call   801006b0 <cprintf>
      myproc()->killed = 1;
80105f49:	e8 d2 db ff ff       	call   80103b20 <myproc>
    break;
80105f4e:	83 c4 10             	add    $0x10,%esp
      myproc()->killed = 1;
80105f51:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    break;
80105f58:	e9 25 fd ff ff       	jmp    80105c82 <trap+0x42>
              if((mem = kalloc()) == 0) {
80105f5d:	e8 9e c7 ff ff       	call   80102700 <kalloc>
80105f62:	89 c2                	mov    %eax,%edx
80105f64:	85 c0                	test   %eax,%eax
80105f66:	74 3d                	je     80105fa5 <trap+0x365>
              memmove(mem, (char*)P2V(pa), PGSIZE);
80105f68:	83 ec 04             	sub    $0x4,%esp
80105f6b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80105f71:	68 00 10 00 00       	push   $0x1000
80105f76:	50                   	push   %eax
80105f77:	52                   	push   %edx
80105f78:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105f7b:	e8 80 ea ff ff       	call   80104a00 <memmove>
              dec_ref(pa);
80105f80:	89 3c 24             	mov    %edi,(%esp)
80105f83:	e8 68 c8 ff ff       	call   801027f0 <dec_ref>
              *pte = V2P(mem) | flags;
80105f88:	8b 06                	mov    (%esi),%eax
80105f8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105f8d:	83 c4 10             	add    $0x10,%esp
80105f90:	25 ff 0e 00 00       	and    $0xeff,%eax
80105f95:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80105f9b:	09 d0                	or     %edx,%eax
80105f9d:	83 c8 02             	or     $0x2,%eax
80105fa0:	e9 06 ff ff ff       	jmp    80105eab <trap+0x26b>
                  cprintf("CoW: Out of memory\n");
80105fa5:	83 ec 0c             	sub    $0xc,%esp
80105fa8:	68 87 7b 10 80       	push   $0x80107b87
80105fad:	e8 fe a6 ff ff       	call   801006b0 <cprintf>
                  myproc()->killed = 1;
80105fb2:	e8 69 db ff ff       	call   80103b20 <myproc>
                  break;
80105fb7:	83 c4 10             	add    $0x10,%esp
                  myproc()->killed = 1;
80105fba:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                  break;
80105fc1:	e9 bc fc ff ff       	jmp    80105c82 <trap+0x42>
80105fc6:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fc9:	e8 32 db ff ff       	call   80103b00 <cpuid>
80105fce:	83 ec 0c             	sub    $0xc,%esp
80105fd1:	56                   	push   %esi
80105fd2:	57                   	push   %edi
80105fd3:	50                   	push   %eax
80105fd4:	ff 73 30             	push   0x30(%ebx)
80105fd7:	68 10 7e 10 80       	push   $0x80107e10
80105fdc:	e8 cf a6 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105fe1:	83 c4 14             	add    $0x14,%esp
80105fe4:	68 9b 7b 10 80       	push   $0x80107b9b
80105fe9:	e8 92 a3 ff ff       	call   80100380 <panic>
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ff0:	a1 c0 34 12 80       	mov    0x801234c0,%eax
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	74 17                	je     80106010 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ff9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ffe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fff:	a8 01                	test   $0x1,%al
80106001:	74 0d                	je     80106010 <uartgetc+0x20>
80106003:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106008:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106009:	0f b6 c0             	movzbl %al,%eax
8010600c:	c3                   	ret
8010600d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106015:	c3                   	ret
80106016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010601d:	00 
8010601e:	66 90                	xchg   %ax,%ax

80106020 <uartinit>:
{
80106020:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106021:	31 c9                	xor    %ecx,%ecx
80106023:	89 c8                	mov    %ecx,%eax
80106025:	89 e5                	mov    %esp,%ebp
80106027:	57                   	push   %edi
80106028:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010602d:	56                   	push   %esi
8010602e:	89 fa                	mov    %edi,%edx
80106030:	53                   	push   %ebx
80106031:	83 ec 1c             	sub    $0x1c,%esp
80106034:	ee                   	out    %al,(%dx)
80106035:	be fb 03 00 00       	mov    $0x3fb,%esi
8010603a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010603f:	89 f2                	mov    %esi,%edx
80106041:	ee                   	out    %al,(%dx)
80106042:	b8 0c 00 00 00       	mov    $0xc,%eax
80106047:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010604c:	ee                   	out    %al,(%dx)
8010604d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106052:	89 c8                	mov    %ecx,%eax
80106054:	89 da                	mov    %ebx,%edx
80106056:	ee                   	out    %al,(%dx)
80106057:	b8 03 00 00 00       	mov    $0x3,%eax
8010605c:	89 f2                	mov    %esi,%edx
8010605e:	ee                   	out    %al,(%dx)
8010605f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106064:	89 c8                	mov    %ecx,%eax
80106066:	ee                   	out    %al,(%dx)
80106067:	b8 01 00 00 00       	mov    $0x1,%eax
8010606c:	89 da                	mov    %ebx,%edx
8010606e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010606f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106074:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106075:	3c ff                	cmp    $0xff,%al
80106077:	0f 84 7c 00 00 00    	je     801060f9 <uartinit+0xd9>
  uart = 1;
8010607d:	c7 05 c0 34 12 80 01 	movl   $0x1,0x801234c0
80106084:	00 00 00 
80106087:	89 fa                	mov    %edi,%edx
80106089:	ec                   	in     (%dx),%al
8010608a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010608f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106090:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106093:	bf a0 7b 10 80       	mov    $0x80107ba0,%edi
80106098:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010609d:	6a 00                	push   $0x0
8010609f:	6a 04                	push   $0x4
801060a1:	e8 ba c3 ff ff       	call   80102460 <ioapicenable>
801060a6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060a9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
801060ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
801060b0:	a1 c0 34 12 80       	mov    0x801234c0,%eax
801060b5:	85 c0                	test   %eax,%eax
801060b7:	74 32                	je     801060eb <uartinit+0xcb>
801060b9:	89 f2                	mov    %esi,%edx
801060bb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060bc:	a8 20                	test   $0x20,%al
801060be:	75 21                	jne    801060e1 <uartinit+0xc1>
801060c0:	bb 80 00 00 00       	mov    $0x80,%ebx
801060c5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801060c8:	83 ec 0c             	sub    $0xc,%esp
801060cb:	6a 0a                	push   $0xa
801060cd:	e8 fe c9 ff ff       	call   80102ad0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060d2:	83 c4 10             	add    $0x10,%esp
801060d5:	83 eb 01             	sub    $0x1,%ebx
801060d8:	74 07                	je     801060e1 <uartinit+0xc1>
801060da:	89 f2                	mov    %esi,%edx
801060dc:	ec                   	in     (%dx),%al
801060dd:	a8 20                	test   $0x20,%al
801060df:	74 e7                	je     801060c8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060e1:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060e6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801060ea:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801060eb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801060ef:	83 c7 01             	add    $0x1,%edi
801060f2:	88 45 e7             	mov    %al,-0x19(%ebp)
801060f5:	84 c0                	test   %al,%al
801060f7:	75 b7                	jne    801060b0 <uartinit+0x90>
}
801060f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060fc:	5b                   	pop    %ebx
801060fd:	5e                   	pop    %esi
801060fe:	5f                   	pop    %edi
801060ff:	5d                   	pop    %ebp
80106100:	c3                   	ret
80106101:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106108:	00 
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106110 <uartputc>:
  if(!uart)
80106110:	a1 c0 34 12 80       	mov    0x801234c0,%eax
80106115:	85 c0                	test   %eax,%eax
80106117:	74 4f                	je     80106168 <uartputc+0x58>
{
80106119:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010611a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010611f:	89 e5                	mov    %esp,%ebp
80106121:	56                   	push   %esi
80106122:	53                   	push   %ebx
80106123:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106124:	a8 20                	test   $0x20,%al
80106126:	75 29                	jne    80106151 <uartputc+0x41>
80106128:	bb 80 00 00 00       	mov    $0x80,%ebx
8010612d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	6a 0a                	push   $0xa
8010613d:	e8 8e c9 ff ff       	call   80102ad0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106142:	83 c4 10             	add    $0x10,%esp
80106145:	83 eb 01             	sub    $0x1,%ebx
80106148:	74 07                	je     80106151 <uartputc+0x41>
8010614a:	89 f2                	mov    %esi,%edx
8010614c:	ec                   	in     (%dx),%al
8010614d:	a8 20                	test   $0x20,%al
8010614f:	74 e7                	je     80106138 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106151:	8b 45 08             	mov    0x8(%ebp),%eax
80106154:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106159:	ee                   	out    %al,(%dx)
}
8010615a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010615d:	5b                   	pop    %ebx
8010615e:	5e                   	pop    %esi
8010615f:	5d                   	pop    %ebp
80106160:	c3                   	ret
80106161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106168:	c3                   	ret
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106170 <uartintr>:

void
uartintr(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106176:	68 f0 5f 10 80       	push   $0x80105ff0
8010617b:	e8 20 a7 ff ff       	call   801008a0 <consoleintr>
}
80106180:	83 c4 10             	add    $0x10,%esp
80106183:	c9                   	leave
80106184:	c3                   	ret

80106185 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $0
80106187:	6a 00                	push   $0x0
  jmp alltraps
80106189:	e9 d7 f9 ff ff       	jmp    80105b65 <alltraps>

8010618e <vector1>:
.globl vector1
vector1:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $1
80106190:	6a 01                	push   $0x1
  jmp alltraps
80106192:	e9 ce f9 ff ff       	jmp    80105b65 <alltraps>

80106197 <vector2>:
.globl vector2
vector2:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $2
80106199:	6a 02                	push   $0x2
  jmp alltraps
8010619b:	e9 c5 f9 ff ff       	jmp    80105b65 <alltraps>

801061a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $3
801061a2:	6a 03                	push   $0x3
  jmp alltraps
801061a4:	e9 bc f9 ff ff       	jmp    80105b65 <alltraps>

801061a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $4
801061ab:	6a 04                	push   $0x4
  jmp alltraps
801061ad:	e9 b3 f9 ff ff       	jmp    80105b65 <alltraps>

801061b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $5
801061b4:	6a 05                	push   $0x5
  jmp alltraps
801061b6:	e9 aa f9 ff ff       	jmp    80105b65 <alltraps>

801061bb <vector6>:
.globl vector6
vector6:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $6
801061bd:	6a 06                	push   $0x6
  jmp alltraps
801061bf:	e9 a1 f9 ff ff       	jmp    80105b65 <alltraps>

801061c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $7
801061c6:	6a 07                	push   $0x7
  jmp alltraps
801061c8:	e9 98 f9 ff ff       	jmp    80105b65 <alltraps>

801061cd <vector8>:
.globl vector8
vector8:
  pushl $8
801061cd:	6a 08                	push   $0x8
  jmp alltraps
801061cf:	e9 91 f9 ff ff       	jmp    80105b65 <alltraps>

801061d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $9
801061d6:	6a 09                	push   $0x9
  jmp alltraps
801061d8:	e9 88 f9 ff ff       	jmp    80105b65 <alltraps>

801061dd <vector10>:
.globl vector10
vector10:
  pushl $10
801061dd:	6a 0a                	push   $0xa
  jmp alltraps
801061df:	e9 81 f9 ff ff       	jmp    80105b65 <alltraps>

801061e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061e4:	6a 0b                	push   $0xb
  jmp alltraps
801061e6:	e9 7a f9 ff ff       	jmp    80105b65 <alltraps>

801061eb <vector12>:
.globl vector12
vector12:
  pushl $12
801061eb:	6a 0c                	push   $0xc
  jmp alltraps
801061ed:	e9 73 f9 ff ff       	jmp    80105b65 <alltraps>

801061f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061f2:	6a 0d                	push   $0xd
  jmp alltraps
801061f4:	e9 6c f9 ff ff       	jmp    80105b65 <alltraps>

801061f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061f9:	6a 0e                	push   $0xe
  jmp alltraps
801061fb:	e9 65 f9 ff ff       	jmp    80105b65 <alltraps>

80106200 <vector15>:
.globl vector15
vector15:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $15
80106202:	6a 0f                	push   $0xf
  jmp alltraps
80106204:	e9 5c f9 ff ff       	jmp    80105b65 <alltraps>

80106209 <vector16>:
.globl vector16
vector16:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $16
8010620b:	6a 10                	push   $0x10
  jmp alltraps
8010620d:	e9 53 f9 ff ff       	jmp    80105b65 <alltraps>

80106212 <vector17>:
.globl vector17
vector17:
  pushl $17
80106212:	6a 11                	push   $0x11
  jmp alltraps
80106214:	e9 4c f9 ff ff       	jmp    80105b65 <alltraps>

80106219 <vector18>:
.globl vector18
vector18:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $18
8010621b:	6a 12                	push   $0x12
  jmp alltraps
8010621d:	e9 43 f9 ff ff       	jmp    80105b65 <alltraps>

80106222 <vector19>:
.globl vector19
vector19:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $19
80106224:	6a 13                	push   $0x13
  jmp alltraps
80106226:	e9 3a f9 ff ff       	jmp    80105b65 <alltraps>

8010622b <vector20>:
.globl vector20
vector20:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $20
8010622d:	6a 14                	push   $0x14
  jmp alltraps
8010622f:	e9 31 f9 ff ff       	jmp    80105b65 <alltraps>

80106234 <vector21>:
.globl vector21
vector21:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $21
80106236:	6a 15                	push   $0x15
  jmp alltraps
80106238:	e9 28 f9 ff ff       	jmp    80105b65 <alltraps>

8010623d <vector22>:
.globl vector22
vector22:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $22
8010623f:	6a 16                	push   $0x16
  jmp alltraps
80106241:	e9 1f f9 ff ff       	jmp    80105b65 <alltraps>

80106246 <vector23>:
.globl vector23
vector23:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $23
80106248:	6a 17                	push   $0x17
  jmp alltraps
8010624a:	e9 16 f9 ff ff       	jmp    80105b65 <alltraps>

8010624f <vector24>:
.globl vector24
vector24:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $24
80106251:	6a 18                	push   $0x18
  jmp alltraps
80106253:	e9 0d f9 ff ff       	jmp    80105b65 <alltraps>

80106258 <vector25>:
.globl vector25
vector25:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $25
8010625a:	6a 19                	push   $0x19
  jmp alltraps
8010625c:	e9 04 f9 ff ff       	jmp    80105b65 <alltraps>

80106261 <vector26>:
.globl vector26
vector26:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $26
80106263:	6a 1a                	push   $0x1a
  jmp alltraps
80106265:	e9 fb f8 ff ff       	jmp    80105b65 <alltraps>

8010626a <vector27>:
.globl vector27
vector27:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $27
8010626c:	6a 1b                	push   $0x1b
  jmp alltraps
8010626e:	e9 f2 f8 ff ff       	jmp    80105b65 <alltraps>

80106273 <vector28>:
.globl vector28
vector28:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $28
80106275:	6a 1c                	push   $0x1c
  jmp alltraps
80106277:	e9 e9 f8 ff ff       	jmp    80105b65 <alltraps>

8010627c <vector29>:
.globl vector29
vector29:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $29
8010627e:	6a 1d                	push   $0x1d
  jmp alltraps
80106280:	e9 e0 f8 ff ff       	jmp    80105b65 <alltraps>

80106285 <vector30>:
.globl vector30
vector30:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $30
80106287:	6a 1e                	push   $0x1e
  jmp alltraps
80106289:	e9 d7 f8 ff ff       	jmp    80105b65 <alltraps>

8010628e <vector31>:
.globl vector31
vector31:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $31
80106290:	6a 1f                	push   $0x1f
  jmp alltraps
80106292:	e9 ce f8 ff ff       	jmp    80105b65 <alltraps>

80106297 <vector32>:
.globl vector32
vector32:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $32
80106299:	6a 20                	push   $0x20
  jmp alltraps
8010629b:	e9 c5 f8 ff ff       	jmp    80105b65 <alltraps>

801062a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $33
801062a2:	6a 21                	push   $0x21
  jmp alltraps
801062a4:	e9 bc f8 ff ff       	jmp    80105b65 <alltraps>

801062a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $34
801062ab:	6a 22                	push   $0x22
  jmp alltraps
801062ad:	e9 b3 f8 ff ff       	jmp    80105b65 <alltraps>

801062b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $35
801062b4:	6a 23                	push   $0x23
  jmp alltraps
801062b6:	e9 aa f8 ff ff       	jmp    80105b65 <alltraps>

801062bb <vector36>:
.globl vector36
vector36:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $36
801062bd:	6a 24                	push   $0x24
  jmp alltraps
801062bf:	e9 a1 f8 ff ff       	jmp    80105b65 <alltraps>

801062c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $37
801062c6:	6a 25                	push   $0x25
  jmp alltraps
801062c8:	e9 98 f8 ff ff       	jmp    80105b65 <alltraps>

801062cd <vector38>:
.globl vector38
vector38:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $38
801062cf:	6a 26                	push   $0x26
  jmp alltraps
801062d1:	e9 8f f8 ff ff       	jmp    80105b65 <alltraps>

801062d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $39
801062d8:	6a 27                	push   $0x27
  jmp alltraps
801062da:	e9 86 f8 ff ff       	jmp    80105b65 <alltraps>

801062df <vector40>:
.globl vector40
vector40:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $40
801062e1:	6a 28                	push   $0x28
  jmp alltraps
801062e3:	e9 7d f8 ff ff       	jmp    80105b65 <alltraps>

801062e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $41
801062ea:	6a 29                	push   $0x29
  jmp alltraps
801062ec:	e9 74 f8 ff ff       	jmp    80105b65 <alltraps>

801062f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $42
801062f3:	6a 2a                	push   $0x2a
  jmp alltraps
801062f5:	e9 6b f8 ff ff       	jmp    80105b65 <alltraps>

801062fa <vector43>:
.globl vector43
vector43:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $43
801062fc:	6a 2b                	push   $0x2b
  jmp alltraps
801062fe:	e9 62 f8 ff ff       	jmp    80105b65 <alltraps>

80106303 <vector44>:
.globl vector44
vector44:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $44
80106305:	6a 2c                	push   $0x2c
  jmp alltraps
80106307:	e9 59 f8 ff ff       	jmp    80105b65 <alltraps>

8010630c <vector45>:
.globl vector45
vector45:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $45
8010630e:	6a 2d                	push   $0x2d
  jmp alltraps
80106310:	e9 50 f8 ff ff       	jmp    80105b65 <alltraps>

80106315 <vector46>:
.globl vector46
vector46:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $46
80106317:	6a 2e                	push   $0x2e
  jmp alltraps
80106319:	e9 47 f8 ff ff       	jmp    80105b65 <alltraps>

8010631e <vector47>:
.globl vector47
vector47:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $47
80106320:	6a 2f                	push   $0x2f
  jmp alltraps
80106322:	e9 3e f8 ff ff       	jmp    80105b65 <alltraps>

80106327 <vector48>:
.globl vector48
vector48:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $48
80106329:	6a 30                	push   $0x30
  jmp alltraps
8010632b:	e9 35 f8 ff ff       	jmp    80105b65 <alltraps>

80106330 <vector49>:
.globl vector49
vector49:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $49
80106332:	6a 31                	push   $0x31
  jmp alltraps
80106334:	e9 2c f8 ff ff       	jmp    80105b65 <alltraps>

80106339 <vector50>:
.globl vector50
vector50:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $50
8010633b:	6a 32                	push   $0x32
  jmp alltraps
8010633d:	e9 23 f8 ff ff       	jmp    80105b65 <alltraps>

80106342 <vector51>:
.globl vector51
vector51:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $51
80106344:	6a 33                	push   $0x33
  jmp alltraps
80106346:	e9 1a f8 ff ff       	jmp    80105b65 <alltraps>

8010634b <vector52>:
.globl vector52
vector52:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $52
8010634d:	6a 34                	push   $0x34
  jmp alltraps
8010634f:	e9 11 f8 ff ff       	jmp    80105b65 <alltraps>

80106354 <vector53>:
.globl vector53
vector53:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $53
80106356:	6a 35                	push   $0x35
  jmp alltraps
80106358:	e9 08 f8 ff ff       	jmp    80105b65 <alltraps>

8010635d <vector54>:
.globl vector54
vector54:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $54
8010635f:	6a 36                	push   $0x36
  jmp alltraps
80106361:	e9 ff f7 ff ff       	jmp    80105b65 <alltraps>

80106366 <vector55>:
.globl vector55
vector55:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $55
80106368:	6a 37                	push   $0x37
  jmp alltraps
8010636a:	e9 f6 f7 ff ff       	jmp    80105b65 <alltraps>

8010636f <vector56>:
.globl vector56
vector56:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $56
80106371:	6a 38                	push   $0x38
  jmp alltraps
80106373:	e9 ed f7 ff ff       	jmp    80105b65 <alltraps>

80106378 <vector57>:
.globl vector57
vector57:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $57
8010637a:	6a 39                	push   $0x39
  jmp alltraps
8010637c:	e9 e4 f7 ff ff       	jmp    80105b65 <alltraps>

80106381 <vector58>:
.globl vector58
vector58:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $58
80106383:	6a 3a                	push   $0x3a
  jmp alltraps
80106385:	e9 db f7 ff ff       	jmp    80105b65 <alltraps>

8010638a <vector59>:
.globl vector59
vector59:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $59
8010638c:	6a 3b                	push   $0x3b
  jmp alltraps
8010638e:	e9 d2 f7 ff ff       	jmp    80105b65 <alltraps>

80106393 <vector60>:
.globl vector60
vector60:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $60
80106395:	6a 3c                	push   $0x3c
  jmp alltraps
80106397:	e9 c9 f7 ff ff       	jmp    80105b65 <alltraps>

8010639c <vector61>:
.globl vector61
vector61:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $61
8010639e:	6a 3d                	push   $0x3d
  jmp alltraps
801063a0:	e9 c0 f7 ff ff       	jmp    80105b65 <alltraps>

801063a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $62
801063a7:	6a 3e                	push   $0x3e
  jmp alltraps
801063a9:	e9 b7 f7 ff ff       	jmp    80105b65 <alltraps>

801063ae <vector63>:
.globl vector63
vector63:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $63
801063b0:	6a 3f                	push   $0x3f
  jmp alltraps
801063b2:	e9 ae f7 ff ff       	jmp    80105b65 <alltraps>

801063b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $64
801063b9:	6a 40                	push   $0x40
  jmp alltraps
801063bb:	e9 a5 f7 ff ff       	jmp    80105b65 <alltraps>

801063c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $65
801063c2:	6a 41                	push   $0x41
  jmp alltraps
801063c4:	e9 9c f7 ff ff       	jmp    80105b65 <alltraps>

801063c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $66
801063cb:	6a 42                	push   $0x42
  jmp alltraps
801063cd:	e9 93 f7 ff ff       	jmp    80105b65 <alltraps>

801063d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $67
801063d4:	6a 43                	push   $0x43
  jmp alltraps
801063d6:	e9 8a f7 ff ff       	jmp    80105b65 <alltraps>

801063db <vector68>:
.globl vector68
vector68:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $68
801063dd:	6a 44                	push   $0x44
  jmp alltraps
801063df:	e9 81 f7 ff ff       	jmp    80105b65 <alltraps>

801063e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $69
801063e6:	6a 45                	push   $0x45
  jmp alltraps
801063e8:	e9 78 f7 ff ff       	jmp    80105b65 <alltraps>

801063ed <vector70>:
.globl vector70
vector70:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $70
801063ef:	6a 46                	push   $0x46
  jmp alltraps
801063f1:	e9 6f f7 ff ff       	jmp    80105b65 <alltraps>

801063f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $71
801063f8:	6a 47                	push   $0x47
  jmp alltraps
801063fa:	e9 66 f7 ff ff       	jmp    80105b65 <alltraps>

801063ff <vector72>:
.globl vector72
vector72:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $72
80106401:	6a 48                	push   $0x48
  jmp alltraps
80106403:	e9 5d f7 ff ff       	jmp    80105b65 <alltraps>

80106408 <vector73>:
.globl vector73
vector73:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $73
8010640a:	6a 49                	push   $0x49
  jmp alltraps
8010640c:	e9 54 f7 ff ff       	jmp    80105b65 <alltraps>

80106411 <vector74>:
.globl vector74
vector74:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $74
80106413:	6a 4a                	push   $0x4a
  jmp alltraps
80106415:	e9 4b f7 ff ff       	jmp    80105b65 <alltraps>

8010641a <vector75>:
.globl vector75
vector75:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $75
8010641c:	6a 4b                	push   $0x4b
  jmp alltraps
8010641e:	e9 42 f7 ff ff       	jmp    80105b65 <alltraps>

80106423 <vector76>:
.globl vector76
vector76:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $76
80106425:	6a 4c                	push   $0x4c
  jmp alltraps
80106427:	e9 39 f7 ff ff       	jmp    80105b65 <alltraps>

8010642c <vector77>:
.globl vector77
vector77:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $77
8010642e:	6a 4d                	push   $0x4d
  jmp alltraps
80106430:	e9 30 f7 ff ff       	jmp    80105b65 <alltraps>

80106435 <vector78>:
.globl vector78
vector78:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $78
80106437:	6a 4e                	push   $0x4e
  jmp alltraps
80106439:	e9 27 f7 ff ff       	jmp    80105b65 <alltraps>

8010643e <vector79>:
.globl vector79
vector79:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $79
80106440:	6a 4f                	push   $0x4f
  jmp alltraps
80106442:	e9 1e f7 ff ff       	jmp    80105b65 <alltraps>

80106447 <vector80>:
.globl vector80
vector80:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $80
80106449:	6a 50                	push   $0x50
  jmp alltraps
8010644b:	e9 15 f7 ff ff       	jmp    80105b65 <alltraps>

80106450 <vector81>:
.globl vector81
vector81:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $81
80106452:	6a 51                	push   $0x51
  jmp alltraps
80106454:	e9 0c f7 ff ff       	jmp    80105b65 <alltraps>

80106459 <vector82>:
.globl vector82
vector82:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $82
8010645b:	6a 52                	push   $0x52
  jmp alltraps
8010645d:	e9 03 f7 ff ff       	jmp    80105b65 <alltraps>

80106462 <vector83>:
.globl vector83
vector83:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $83
80106464:	6a 53                	push   $0x53
  jmp alltraps
80106466:	e9 fa f6 ff ff       	jmp    80105b65 <alltraps>

8010646b <vector84>:
.globl vector84
vector84:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $84
8010646d:	6a 54                	push   $0x54
  jmp alltraps
8010646f:	e9 f1 f6 ff ff       	jmp    80105b65 <alltraps>

80106474 <vector85>:
.globl vector85
vector85:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $85
80106476:	6a 55                	push   $0x55
  jmp alltraps
80106478:	e9 e8 f6 ff ff       	jmp    80105b65 <alltraps>

8010647d <vector86>:
.globl vector86
vector86:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $86
8010647f:	6a 56                	push   $0x56
  jmp alltraps
80106481:	e9 df f6 ff ff       	jmp    80105b65 <alltraps>

80106486 <vector87>:
.globl vector87
vector87:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $87
80106488:	6a 57                	push   $0x57
  jmp alltraps
8010648a:	e9 d6 f6 ff ff       	jmp    80105b65 <alltraps>

8010648f <vector88>:
.globl vector88
vector88:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $88
80106491:	6a 58                	push   $0x58
  jmp alltraps
80106493:	e9 cd f6 ff ff       	jmp    80105b65 <alltraps>

80106498 <vector89>:
.globl vector89
vector89:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $89
8010649a:	6a 59                	push   $0x59
  jmp alltraps
8010649c:	e9 c4 f6 ff ff       	jmp    80105b65 <alltraps>

801064a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $90
801064a3:	6a 5a                	push   $0x5a
  jmp alltraps
801064a5:	e9 bb f6 ff ff       	jmp    80105b65 <alltraps>

801064aa <vector91>:
.globl vector91
vector91:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $91
801064ac:	6a 5b                	push   $0x5b
  jmp alltraps
801064ae:	e9 b2 f6 ff ff       	jmp    80105b65 <alltraps>

801064b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $92
801064b5:	6a 5c                	push   $0x5c
  jmp alltraps
801064b7:	e9 a9 f6 ff ff       	jmp    80105b65 <alltraps>

801064bc <vector93>:
.globl vector93
vector93:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $93
801064be:	6a 5d                	push   $0x5d
  jmp alltraps
801064c0:	e9 a0 f6 ff ff       	jmp    80105b65 <alltraps>

801064c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $94
801064c7:	6a 5e                	push   $0x5e
  jmp alltraps
801064c9:	e9 97 f6 ff ff       	jmp    80105b65 <alltraps>

801064ce <vector95>:
.globl vector95
vector95:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $95
801064d0:	6a 5f                	push   $0x5f
  jmp alltraps
801064d2:	e9 8e f6 ff ff       	jmp    80105b65 <alltraps>

801064d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $96
801064d9:	6a 60                	push   $0x60
  jmp alltraps
801064db:	e9 85 f6 ff ff       	jmp    80105b65 <alltraps>

801064e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $97
801064e2:	6a 61                	push   $0x61
  jmp alltraps
801064e4:	e9 7c f6 ff ff       	jmp    80105b65 <alltraps>

801064e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $98
801064eb:	6a 62                	push   $0x62
  jmp alltraps
801064ed:	e9 73 f6 ff ff       	jmp    80105b65 <alltraps>

801064f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $99
801064f4:	6a 63                	push   $0x63
  jmp alltraps
801064f6:	e9 6a f6 ff ff       	jmp    80105b65 <alltraps>

801064fb <vector100>:
.globl vector100
vector100:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $100
801064fd:	6a 64                	push   $0x64
  jmp alltraps
801064ff:	e9 61 f6 ff ff       	jmp    80105b65 <alltraps>

80106504 <vector101>:
.globl vector101
vector101:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $101
80106506:	6a 65                	push   $0x65
  jmp alltraps
80106508:	e9 58 f6 ff ff       	jmp    80105b65 <alltraps>

8010650d <vector102>:
.globl vector102
vector102:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $102
8010650f:	6a 66                	push   $0x66
  jmp alltraps
80106511:	e9 4f f6 ff ff       	jmp    80105b65 <alltraps>

80106516 <vector103>:
.globl vector103
vector103:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $103
80106518:	6a 67                	push   $0x67
  jmp alltraps
8010651a:	e9 46 f6 ff ff       	jmp    80105b65 <alltraps>

8010651f <vector104>:
.globl vector104
vector104:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $104
80106521:	6a 68                	push   $0x68
  jmp alltraps
80106523:	e9 3d f6 ff ff       	jmp    80105b65 <alltraps>

80106528 <vector105>:
.globl vector105
vector105:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $105
8010652a:	6a 69                	push   $0x69
  jmp alltraps
8010652c:	e9 34 f6 ff ff       	jmp    80105b65 <alltraps>

80106531 <vector106>:
.globl vector106
vector106:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $106
80106533:	6a 6a                	push   $0x6a
  jmp alltraps
80106535:	e9 2b f6 ff ff       	jmp    80105b65 <alltraps>

8010653a <vector107>:
.globl vector107
vector107:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $107
8010653c:	6a 6b                	push   $0x6b
  jmp alltraps
8010653e:	e9 22 f6 ff ff       	jmp    80105b65 <alltraps>

80106543 <vector108>:
.globl vector108
vector108:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $108
80106545:	6a 6c                	push   $0x6c
  jmp alltraps
80106547:	e9 19 f6 ff ff       	jmp    80105b65 <alltraps>

8010654c <vector109>:
.globl vector109
vector109:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $109
8010654e:	6a 6d                	push   $0x6d
  jmp alltraps
80106550:	e9 10 f6 ff ff       	jmp    80105b65 <alltraps>

80106555 <vector110>:
.globl vector110
vector110:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $110
80106557:	6a 6e                	push   $0x6e
  jmp alltraps
80106559:	e9 07 f6 ff ff       	jmp    80105b65 <alltraps>

8010655e <vector111>:
.globl vector111
vector111:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $111
80106560:	6a 6f                	push   $0x6f
  jmp alltraps
80106562:	e9 fe f5 ff ff       	jmp    80105b65 <alltraps>

80106567 <vector112>:
.globl vector112
vector112:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $112
80106569:	6a 70                	push   $0x70
  jmp alltraps
8010656b:	e9 f5 f5 ff ff       	jmp    80105b65 <alltraps>

80106570 <vector113>:
.globl vector113
vector113:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $113
80106572:	6a 71                	push   $0x71
  jmp alltraps
80106574:	e9 ec f5 ff ff       	jmp    80105b65 <alltraps>

80106579 <vector114>:
.globl vector114
vector114:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $114
8010657b:	6a 72                	push   $0x72
  jmp alltraps
8010657d:	e9 e3 f5 ff ff       	jmp    80105b65 <alltraps>

80106582 <vector115>:
.globl vector115
vector115:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $115
80106584:	6a 73                	push   $0x73
  jmp alltraps
80106586:	e9 da f5 ff ff       	jmp    80105b65 <alltraps>

8010658b <vector116>:
.globl vector116
vector116:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $116
8010658d:	6a 74                	push   $0x74
  jmp alltraps
8010658f:	e9 d1 f5 ff ff       	jmp    80105b65 <alltraps>

80106594 <vector117>:
.globl vector117
vector117:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $117
80106596:	6a 75                	push   $0x75
  jmp alltraps
80106598:	e9 c8 f5 ff ff       	jmp    80105b65 <alltraps>

8010659d <vector118>:
.globl vector118
vector118:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $118
8010659f:	6a 76                	push   $0x76
  jmp alltraps
801065a1:	e9 bf f5 ff ff       	jmp    80105b65 <alltraps>

801065a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $119
801065a8:	6a 77                	push   $0x77
  jmp alltraps
801065aa:	e9 b6 f5 ff ff       	jmp    80105b65 <alltraps>

801065af <vector120>:
.globl vector120
vector120:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $120
801065b1:	6a 78                	push   $0x78
  jmp alltraps
801065b3:	e9 ad f5 ff ff       	jmp    80105b65 <alltraps>

801065b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $121
801065ba:	6a 79                	push   $0x79
  jmp alltraps
801065bc:	e9 a4 f5 ff ff       	jmp    80105b65 <alltraps>

801065c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $122
801065c3:	6a 7a                	push   $0x7a
  jmp alltraps
801065c5:	e9 9b f5 ff ff       	jmp    80105b65 <alltraps>

801065ca <vector123>:
.globl vector123
vector123:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $123
801065cc:	6a 7b                	push   $0x7b
  jmp alltraps
801065ce:	e9 92 f5 ff ff       	jmp    80105b65 <alltraps>

801065d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $124
801065d5:	6a 7c                	push   $0x7c
  jmp alltraps
801065d7:	e9 89 f5 ff ff       	jmp    80105b65 <alltraps>

801065dc <vector125>:
.globl vector125
vector125:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $125
801065de:	6a 7d                	push   $0x7d
  jmp alltraps
801065e0:	e9 80 f5 ff ff       	jmp    80105b65 <alltraps>

801065e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $126
801065e7:	6a 7e                	push   $0x7e
  jmp alltraps
801065e9:	e9 77 f5 ff ff       	jmp    80105b65 <alltraps>

801065ee <vector127>:
.globl vector127
vector127:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $127
801065f0:	6a 7f                	push   $0x7f
  jmp alltraps
801065f2:	e9 6e f5 ff ff       	jmp    80105b65 <alltraps>

801065f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $128
801065f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065fe:	e9 62 f5 ff ff       	jmp    80105b65 <alltraps>

80106603 <vector129>:
.globl vector129
vector129:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $129
80106605:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010660a:	e9 56 f5 ff ff       	jmp    80105b65 <alltraps>

8010660f <vector130>:
.globl vector130
vector130:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $130
80106611:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106616:	e9 4a f5 ff ff       	jmp    80105b65 <alltraps>

8010661b <vector131>:
.globl vector131
vector131:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $131
8010661d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106622:	e9 3e f5 ff ff       	jmp    80105b65 <alltraps>

80106627 <vector132>:
.globl vector132
vector132:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $132
80106629:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010662e:	e9 32 f5 ff ff       	jmp    80105b65 <alltraps>

80106633 <vector133>:
.globl vector133
vector133:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $133
80106635:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010663a:	e9 26 f5 ff ff       	jmp    80105b65 <alltraps>

8010663f <vector134>:
.globl vector134
vector134:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $134
80106641:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106646:	e9 1a f5 ff ff       	jmp    80105b65 <alltraps>

8010664b <vector135>:
.globl vector135
vector135:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $135
8010664d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106652:	e9 0e f5 ff ff       	jmp    80105b65 <alltraps>

80106657 <vector136>:
.globl vector136
vector136:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $136
80106659:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010665e:	e9 02 f5 ff ff       	jmp    80105b65 <alltraps>

80106663 <vector137>:
.globl vector137
vector137:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $137
80106665:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010666a:	e9 f6 f4 ff ff       	jmp    80105b65 <alltraps>

8010666f <vector138>:
.globl vector138
vector138:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $138
80106671:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106676:	e9 ea f4 ff ff       	jmp    80105b65 <alltraps>

8010667b <vector139>:
.globl vector139
vector139:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $139
8010667d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106682:	e9 de f4 ff ff       	jmp    80105b65 <alltraps>

80106687 <vector140>:
.globl vector140
vector140:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $140
80106689:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010668e:	e9 d2 f4 ff ff       	jmp    80105b65 <alltraps>

80106693 <vector141>:
.globl vector141
vector141:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $141
80106695:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010669a:	e9 c6 f4 ff ff       	jmp    80105b65 <alltraps>

8010669f <vector142>:
.globl vector142
vector142:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $142
801066a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066a6:	e9 ba f4 ff ff       	jmp    80105b65 <alltraps>

801066ab <vector143>:
.globl vector143
vector143:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $143
801066ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066b2:	e9 ae f4 ff ff       	jmp    80105b65 <alltraps>

801066b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $144
801066b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066be:	e9 a2 f4 ff ff       	jmp    80105b65 <alltraps>

801066c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $145
801066c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066ca:	e9 96 f4 ff ff       	jmp    80105b65 <alltraps>

801066cf <vector146>:
.globl vector146
vector146:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $146
801066d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066d6:	e9 8a f4 ff ff       	jmp    80105b65 <alltraps>

801066db <vector147>:
.globl vector147
vector147:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $147
801066dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066e2:	e9 7e f4 ff ff       	jmp    80105b65 <alltraps>

801066e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $148
801066e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ee:	e9 72 f4 ff ff       	jmp    80105b65 <alltraps>

801066f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $149
801066f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066fa:	e9 66 f4 ff ff       	jmp    80105b65 <alltraps>

801066ff <vector150>:
.globl vector150
vector150:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $150
80106701:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106706:	e9 5a f4 ff ff       	jmp    80105b65 <alltraps>

8010670b <vector151>:
.globl vector151
vector151:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $151
8010670d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106712:	e9 4e f4 ff ff       	jmp    80105b65 <alltraps>

80106717 <vector152>:
.globl vector152
vector152:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $152
80106719:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010671e:	e9 42 f4 ff ff       	jmp    80105b65 <alltraps>

80106723 <vector153>:
.globl vector153
vector153:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $153
80106725:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010672a:	e9 36 f4 ff ff       	jmp    80105b65 <alltraps>

8010672f <vector154>:
.globl vector154
vector154:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $154
80106731:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106736:	e9 2a f4 ff ff       	jmp    80105b65 <alltraps>

8010673b <vector155>:
.globl vector155
vector155:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $155
8010673d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106742:	e9 1e f4 ff ff       	jmp    80105b65 <alltraps>

80106747 <vector156>:
.globl vector156
vector156:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $156
80106749:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010674e:	e9 12 f4 ff ff       	jmp    80105b65 <alltraps>

80106753 <vector157>:
.globl vector157
vector157:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $157
80106755:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010675a:	e9 06 f4 ff ff       	jmp    80105b65 <alltraps>

8010675f <vector158>:
.globl vector158
vector158:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $158
80106761:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106766:	e9 fa f3 ff ff       	jmp    80105b65 <alltraps>

8010676b <vector159>:
.globl vector159
vector159:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $159
8010676d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106772:	e9 ee f3 ff ff       	jmp    80105b65 <alltraps>

80106777 <vector160>:
.globl vector160
vector160:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $160
80106779:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010677e:	e9 e2 f3 ff ff       	jmp    80105b65 <alltraps>

80106783 <vector161>:
.globl vector161
vector161:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $161
80106785:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010678a:	e9 d6 f3 ff ff       	jmp    80105b65 <alltraps>

8010678f <vector162>:
.globl vector162
vector162:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $162
80106791:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106796:	e9 ca f3 ff ff       	jmp    80105b65 <alltraps>

8010679b <vector163>:
.globl vector163
vector163:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $163
8010679d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067a2:	e9 be f3 ff ff       	jmp    80105b65 <alltraps>

801067a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $164
801067a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067ae:	e9 b2 f3 ff ff       	jmp    80105b65 <alltraps>

801067b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $165
801067b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067ba:	e9 a6 f3 ff ff       	jmp    80105b65 <alltraps>

801067bf <vector166>:
.globl vector166
vector166:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $166
801067c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067c6:	e9 9a f3 ff ff       	jmp    80105b65 <alltraps>

801067cb <vector167>:
.globl vector167
vector167:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $167
801067cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067d2:	e9 8e f3 ff ff       	jmp    80105b65 <alltraps>

801067d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $168
801067d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067de:	e9 82 f3 ff ff       	jmp    80105b65 <alltraps>

801067e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $169
801067e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067ea:	e9 76 f3 ff ff       	jmp    80105b65 <alltraps>

801067ef <vector170>:
.globl vector170
vector170:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $170
801067f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067f6:	e9 6a f3 ff ff       	jmp    80105b65 <alltraps>

801067fb <vector171>:
.globl vector171
vector171:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $171
801067fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106802:	e9 5e f3 ff ff       	jmp    80105b65 <alltraps>

80106807 <vector172>:
.globl vector172
vector172:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $172
80106809:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010680e:	e9 52 f3 ff ff       	jmp    80105b65 <alltraps>

80106813 <vector173>:
.globl vector173
vector173:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $173
80106815:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010681a:	e9 46 f3 ff ff       	jmp    80105b65 <alltraps>

8010681f <vector174>:
.globl vector174
vector174:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $174
80106821:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106826:	e9 3a f3 ff ff       	jmp    80105b65 <alltraps>

8010682b <vector175>:
.globl vector175
vector175:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $175
8010682d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106832:	e9 2e f3 ff ff       	jmp    80105b65 <alltraps>

80106837 <vector176>:
.globl vector176
vector176:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $176
80106839:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010683e:	e9 22 f3 ff ff       	jmp    80105b65 <alltraps>

80106843 <vector177>:
.globl vector177
vector177:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $177
80106845:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010684a:	e9 16 f3 ff ff       	jmp    80105b65 <alltraps>

8010684f <vector178>:
.globl vector178
vector178:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $178
80106851:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106856:	e9 0a f3 ff ff       	jmp    80105b65 <alltraps>

8010685b <vector179>:
.globl vector179
vector179:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $179
8010685d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106862:	e9 fe f2 ff ff       	jmp    80105b65 <alltraps>

80106867 <vector180>:
.globl vector180
vector180:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $180
80106869:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010686e:	e9 f2 f2 ff ff       	jmp    80105b65 <alltraps>

80106873 <vector181>:
.globl vector181
vector181:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $181
80106875:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010687a:	e9 e6 f2 ff ff       	jmp    80105b65 <alltraps>

8010687f <vector182>:
.globl vector182
vector182:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $182
80106881:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106886:	e9 da f2 ff ff       	jmp    80105b65 <alltraps>

8010688b <vector183>:
.globl vector183
vector183:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $183
8010688d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106892:	e9 ce f2 ff ff       	jmp    80105b65 <alltraps>

80106897 <vector184>:
.globl vector184
vector184:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $184
80106899:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010689e:	e9 c2 f2 ff ff       	jmp    80105b65 <alltraps>

801068a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $185
801068a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068aa:	e9 b6 f2 ff ff       	jmp    80105b65 <alltraps>

801068af <vector186>:
.globl vector186
vector186:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $186
801068b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068b6:	e9 aa f2 ff ff       	jmp    80105b65 <alltraps>

801068bb <vector187>:
.globl vector187
vector187:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $187
801068bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068c2:	e9 9e f2 ff ff       	jmp    80105b65 <alltraps>

801068c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $188
801068c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068ce:	e9 92 f2 ff ff       	jmp    80105b65 <alltraps>

801068d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $189
801068d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068da:	e9 86 f2 ff ff       	jmp    80105b65 <alltraps>

801068df <vector190>:
.globl vector190
vector190:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $190
801068e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068e6:	e9 7a f2 ff ff       	jmp    80105b65 <alltraps>

801068eb <vector191>:
.globl vector191
vector191:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $191
801068ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068f2:	e9 6e f2 ff ff       	jmp    80105b65 <alltraps>

801068f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $192
801068f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068fe:	e9 62 f2 ff ff       	jmp    80105b65 <alltraps>

80106903 <vector193>:
.globl vector193
vector193:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $193
80106905:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010690a:	e9 56 f2 ff ff       	jmp    80105b65 <alltraps>

8010690f <vector194>:
.globl vector194
vector194:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $194
80106911:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106916:	e9 4a f2 ff ff       	jmp    80105b65 <alltraps>

8010691b <vector195>:
.globl vector195
vector195:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $195
8010691d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106922:	e9 3e f2 ff ff       	jmp    80105b65 <alltraps>

80106927 <vector196>:
.globl vector196
vector196:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $196
80106929:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010692e:	e9 32 f2 ff ff       	jmp    80105b65 <alltraps>

80106933 <vector197>:
.globl vector197
vector197:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $197
80106935:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010693a:	e9 26 f2 ff ff       	jmp    80105b65 <alltraps>

8010693f <vector198>:
.globl vector198
vector198:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $198
80106941:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106946:	e9 1a f2 ff ff       	jmp    80105b65 <alltraps>

8010694b <vector199>:
.globl vector199
vector199:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $199
8010694d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106952:	e9 0e f2 ff ff       	jmp    80105b65 <alltraps>

80106957 <vector200>:
.globl vector200
vector200:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $200
80106959:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010695e:	e9 02 f2 ff ff       	jmp    80105b65 <alltraps>

80106963 <vector201>:
.globl vector201
vector201:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $201
80106965:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010696a:	e9 f6 f1 ff ff       	jmp    80105b65 <alltraps>

8010696f <vector202>:
.globl vector202
vector202:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $202
80106971:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106976:	e9 ea f1 ff ff       	jmp    80105b65 <alltraps>

8010697b <vector203>:
.globl vector203
vector203:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $203
8010697d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106982:	e9 de f1 ff ff       	jmp    80105b65 <alltraps>

80106987 <vector204>:
.globl vector204
vector204:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $204
80106989:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010698e:	e9 d2 f1 ff ff       	jmp    80105b65 <alltraps>

80106993 <vector205>:
.globl vector205
vector205:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $205
80106995:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010699a:	e9 c6 f1 ff ff       	jmp    80105b65 <alltraps>

8010699f <vector206>:
.globl vector206
vector206:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $206
801069a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069a6:	e9 ba f1 ff ff       	jmp    80105b65 <alltraps>

801069ab <vector207>:
.globl vector207
vector207:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $207
801069ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069b2:	e9 ae f1 ff ff       	jmp    80105b65 <alltraps>

801069b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $208
801069b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069be:	e9 a2 f1 ff ff       	jmp    80105b65 <alltraps>

801069c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $209
801069c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069ca:	e9 96 f1 ff ff       	jmp    80105b65 <alltraps>

801069cf <vector210>:
.globl vector210
vector210:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $210
801069d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069d6:	e9 8a f1 ff ff       	jmp    80105b65 <alltraps>

801069db <vector211>:
.globl vector211
vector211:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $211
801069dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069e2:	e9 7e f1 ff ff       	jmp    80105b65 <alltraps>

801069e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $212
801069e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ee:	e9 72 f1 ff ff       	jmp    80105b65 <alltraps>

801069f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $213
801069f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069fa:	e9 66 f1 ff ff       	jmp    80105b65 <alltraps>

801069ff <vector214>:
.globl vector214
vector214:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $214
80106a01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a06:	e9 5a f1 ff ff       	jmp    80105b65 <alltraps>

80106a0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $215
80106a0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a12:	e9 4e f1 ff ff       	jmp    80105b65 <alltraps>

80106a17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $216
80106a19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a1e:	e9 42 f1 ff ff       	jmp    80105b65 <alltraps>

80106a23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $217
80106a25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a2a:	e9 36 f1 ff ff       	jmp    80105b65 <alltraps>

80106a2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $218
80106a31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a36:	e9 2a f1 ff ff       	jmp    80105b65 <alltraps>

80106a3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $219
80106a3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a42:	e9 1e f1 ff ff       	jmp    80105b65 <alltraps>

80106a47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $220
80106a49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a4e:	e9 12 f1 ff ff       	jmp    80105b65 <alltraps>

80106a53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $221
80106a55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a5a:	e9 06 f1 ff ff       	jmp    80105b65 <alltraps>

80106a5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $222
80106a61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a66:	e9 fa f0 ff ff       	jmp    80105b65 <alltraps>

80106a6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $223
80106a6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a72:	e9 ee f0 ff ff       	jmp    80105b65 <alltraps>

80106a77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $224
80106a79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a7e:	e9 e2 f0 ff ff       	jmp    80105b65 <alltraps>

80106a83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $225
80106a85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a8a:	e9 d6 f0 ff ff       	jmp    80105b65 <alltraps>

80106a8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $226
80106a91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a96:	e9 ca f0 ff ff       	jmp    80105b65 <alltraps>

80106a9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $227
80106a9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106aa2:	e9 be f0 ff ff       	jmp    80105b65 <alltraps>

80106aa7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $228
80106aa9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106aae:	e9 b2 f0 ff ff       	jmp    80105b65 <alltraps>

80106ab3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $229
80106ab5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106aba:	e9 a6 f0 ff ff       	jmp    80105b65 <alltraps>

80106abf <vector230>:
.globl vector230
vector230:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $230
80106ac1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ac6:	e9 9a f0 ff ff       	jmp    80105b65 <alltraps>

80106acb <vector231>:
.globl vector231
vector231:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $231
80106acd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ad2:	e9 8e f0 ff ff       	jmp    80105b65 <alltraps>

80106ad7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $232
80106ad9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ade:	e9 82 f0 ff ff       	jmp    80105b65 <alltraps>

80106ae3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $233
80106ae5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aea:	e9 76 f0 ff ff       	jmp    80105b65 <alltraps>

80106aef <vector234>:
.globl vector234
vector234:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $234
80106af1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106af6:	e9 6a f0 ff ff       	jmp    80105b65 <alltraps>

80106afb <vector235>:
.globl vector235
vector235:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $235
80106afd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b02:	e9 5e f0 ff ff       	jmp    80105b65 <alltraps>

80106b07 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $236
80106b09:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b0e:	e9 52 f0 ff ff       	jmp    80105b65 <alltraps>

80106b13 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $237
80106b15:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b1a:	e9 46 f0 ff ff       	jmp    80105b65 <alltraps>

80106b1f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $238
80106b21:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b26:	e9 3a f0 ff ff       	jmp    80105b65 <alltraps>

80106b2b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $239
80106b2d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b32:	e9 2e f0 ff ff       	jmp    80105b65 <alltraps>

80106b37 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $240
80106b39:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b3e:	e9 22 f0 ff ff       	jmp    80105b65 <alltraps>

80106b43 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $241
80106b45:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b4a:	e9 16 f0 ff ff       	jmp    80105b65 <alltraps>

80106b4f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $242
80106b51:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b56:	e9 0a f0 ff ff       	jmp    80105b65 <alltraps>

80106b5b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $243
80106b5d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b62:	e9 fe ef ff ff       	jmp    80105b65 <alltraps>

80106b67 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $244
80106b69:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b6e:	e9 f2 ef ff ff       	jmp    80105b65 <alltraps>

80106b73 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $245
80106b75:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b7a:	e9 e6 ef ff ff       	jmp    80105b65 <alltraps>

80106b7f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $246
80106b81:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b86:	e9 da ef ff ff       	jmp    80105b65 <alltraps>

80106b8b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $247
80106b8d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b92:	e9 ce ef ff ff       	jmp    80105b65 <alltraps>

80106b97 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $248
80106b99:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b9e:	e9 c2 ef ff ff       	jmp    80105b65 <alltraps>

80106ba3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $249
80106ba5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106baa:	e9 b6 ef ff ff       	jmp    80105b65 <alltraps>

80106baf <vector250>:
.globl vector250
vector250:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $250
80106bb1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106bb6:	e9 aa ef ff ff       	jmp    80105b65 <alltraps>

80106bbb <vector251>:
.globl vector251
vector251:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $251
80106bbd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106bc2:	e9 9e ef ff ff       	jmp    80105b65 <alltraps>

80106bc7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $252
80106bc9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bce:	e9 92 ef ff ff       	jmp    80105b65 <alltraps>

80106bd3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $253
80106bd5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106bda:	e9 86 ef ff ff       	jmp    80105b65 <alltraps>

80106bdf <vector254>:
.globl vector254
vector254:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $254
80106be1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106be6:	e9 7a ef ff ff       	jmp    80105b65 <alltraps>

80106beb <vector255>:
.globl vector255
vector255:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $255
80106bed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bf2:	e9 6e ef ff ff       	jmp    80105b65 <alltraps>
80106bf7:	66 90                	xchg   %ax,%ax
80106bf9:	66 90                	xchg   %ax,%ax
80106bfb:	66 90                	xchg   %ax,%ax
80106bfd:	66 90                	xchg   %ax,%ax
80106bff:	90                   	nop

80106c00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c0c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c12:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106c15:	39 d3                	cmp    %edx,%ebx
80106c17:	73 56                	jae    80106c6f <deallocuvm.part.0+0x6f>
80106c19:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106c1c:	89 c6                	mov    %eax,%esi
80106c1e:	89 d7                	mov    %edx,%edi
80106c20:	eb 12                	jmp    80106c34 <deallocuvm.part.0+0x34>
80106c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c28:	83 c2 01             	add    $0x1,%edx
80106c2b:	89 d3                	mov    %edx,%ebx
80106c2d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c30:	39 fb                	cmp    %edi,%ebx
80106c32:	73 38                	jae    80106c6c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106c34:	89 da                	mov    %ebx,%edx
80106c36:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c39:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106c3c:	a8 01                	test   $0x1,%al
80106c3e:	74 e8                	je     80106c28 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106c40:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c47:	c1 e9 0a             	shr    $0xa,%ecx
80106c4a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106c50:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106c57:	85 c0                	test   %eax,%eax
80106c59:	74 cd                	je     80106c28 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106c5b:	8b 10                	mov    (%eax),%edx
80106c5d:	f6 c2 01             	test   $0x1,%dl
80106c60:	75 1e                	jne    80106c80 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106c62:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c68:	39 fb                	cmp    %edi,%ebx
80106c6a:	72 c8                	jb     80106c34 <deallocuvm.part.0+0x34>
80106c6c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c72:	89 c8                	mov    %ecx,%eax
80106c74:	5b                   	pop    %ebx
80106c75:	5e                   	pop    %esi
80106c76:	5f                   	pop    %edi
80106c77:	5d                   	pop    %ebp
80106c78:	c3                   	ret
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106c80:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c86:	74 26                	je     80106cae <deallocuvm.part.0+0xae>
      kfree(v);
80106c88:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c8b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c94:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106c9a:	52                   	push   %edx
80106c9b:	e8 00 b8 ff ff       	call   801024a0 <kfree>
      *pte = 0;
80106ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106ca3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106cac:	eb 82                	jmp    80106c30 <deallocuvm.part.0+0x30>
        panic("kfree");
80106cae:	83 ec 0c             	sub    $0xc,%esp
80106cb1:	68 4c 79 10 80       	push   $0x8010794c
80106cb6:	e8 c5 96 ff ff       	call   80100380 <panic>
80106cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106cc0 <mappages>:
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106cc6:	89 d3                	mov    %edx,%ebx
80106cc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cce:	83 ec 1c             	sub    $0x1c,%esp
80106cd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cd4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce3:	29 d8                	sub    %ebx,%eax
80106ce5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ce8:	eb 3f                	jmp    80106d29 <mappages+0x69>
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cf0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cf2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cf7:	c1 ea 0a             	shr    $0xa,%edx
80106cfa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d00:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d07:	85 c0                	test   %eax,%eax
80106d09:	74 75                	je     80106d80 <mappages+0xc0>
    if(*pte & PTE_P)
80106d0b:	f6 00 01             	testb  $0x1,(%eax)
80106d0e:	0f 85 86 00 00 00    	jne    80106d9a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d14:	0b 75 0c             	or     0xc(%ebp),%esi
80106d17:	83 ce 01             	or     $0x1,%esi
80106d1a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d1f:	39 c3                	cmp    %eax,%ebx
80106d21:	74 6d                	je     80106d90 <mappages+0xd0>
    a += PGSIZE;
80106d23:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d2c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106d2f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106d32:	89 d8                	mov    %ebx,%eax
80106d34:	c1 e8 16             	shr    $0x16,%eax
80106d37:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d3a:	8b 07                	mov    (%edi),%eax
80106d3c:	a8 01                	test   $0x1,%al
80106d3e:	75 b0                	jne    80106cf0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d40:	e8 bb b9 ff ff       	call   80102700 <kalloc>
80106d45:	85 c0                	test   %eax,%eax
80106d47:	74 37                	je     80106d80 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d49:	83 ec 04             	sub    $0x4,%esp
80106d4c:	68 00 10 00 00       	push   $0x1000
80106d51:	6a 00                	push   $0x0
80106d53:	50                   	push   %eax
80106d54:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d57:	e8 14 dc ff ff       	call   80104970 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d5f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d62:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d68:	83 c8 07             	or     $0x7,%eax
80106d6b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d6d:	89 d8                	mov    %ebx,%eax
80106d6f:	c1 e8 0a             	shr    $0xa,%eax
80106d72:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d77:	01 d0                	add    %edx,%eax
80106d79:	eb 90                	jmp    80106d0b <mappages+0x4b>
80106d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d88:	5b                   	pop    %ebx
80106d89:	5e                   	pop    %esi
80106d8a:	5f                   	pop    %edi
80106d8b:	5d                   	pop    %ebp
80106d8c:	c3                   	ret
80106d8d:	8d 76 00             	lea    0x0(%esi),%esi
80106d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d93:	31 c0                	xor    %eax,%eax
}
80106d95:	5b                   	pop    %ebx
80106d96:	5e                   	pop    %esi
80106d97:	5f                   	pop    %edi
80106d98:	5d                   	pop    %ebp
80106d99:	c3                   	ret
      panic("remap");
80106d9a:	83 ec 0c             	sub    $0xc,%esp
80106d9d:	68 a8 7b 10 80       	push   $0x80107ba8
80106da2:	e8 d9 95 ff ff       	call   80100380 <panic>
80106da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dae:	00 
80106daf:	90                   	nop

80106db0 <seginit>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106db6:	e8 45 cd ff ff       	call   80103b00 <cpuid>
  pd[0] = size-1;
80106dbb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dc0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106dc6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106dca:	c7 80 18 08 12 80 ff 	movl   $0xffff,-0x7fedf7e8(%eax)
80106dd1:	ff 00 00 
80106dd4:	c7 80 1c 08 12 80 00 	movl   $0xcf9a00,-0x7fedf7e4(%eax)
80106ddb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dde:	c7 80 20 08 12 80 ff 	movl   $0xffff,-0x7fedf7e0(%eax)
80106de5:	ff 00 00 
80106de8:	c7 80 24 08 12 80 00 	movl   $0xcf9200,-0x7fedf7dc(%eax)
80106def:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106df2:	c7 80 28 08 12 80 ff 	movl   $0xffff,-0x7fedf7d8(%eax)
80106df9:	ff 00 00 
80106dfc:	c7 80 2c 08 12 80 00 	movl   $0xcffa00,-0x7fedf7d4(%eax)
80106e03:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e06:	c7 80 30 08 12 80 ff 	movl   $0xffff,-0x7fedf7d0(%eax)
80106e0d:	ff 00 00 
80106e10:	c7 80 34 08 12 80 00 	movl   $0xcff200,-0x7fedf7cc(%eax)
80106e17:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e1a:	05 10 08 12 80       	add    $0x80120810,%eax
  pd[1] = (uint)p;
80106e1f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e23:	c1 e8 10             	shr    $0x10,%eax
80106e26:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e2a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e2d:	0f 01 10             	lgdtl  (%eax)
}
80106e30:	c9                   	leave
80106e31:	c3                   	ret
80106e32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e39:	00 
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e40 <walkpgdir>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 0c             	sub    $0xc,%esp
80106e49:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80106e4c:	8b 55 08             	mov    0x8(%ebp),%edx
80106e4f:	89 fe                	mov    %edi,%esi
80106e51:	c1 ee 16             	shr    $0x16,%esi
80106e54:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106e57:	8b 1e                	mov    (%esi),%ebx
80106e59:	f6 c3 01             	test   $0x1,%bl
80106e5c:	74 22                	je     80106e80 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e5e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e64:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80106e6a:	89 f8                	mov    %edi,%eax
}
80106e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e6f:	c1 e8 0a             	shr    $0xa,%eax
80106e72:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e77:	01 d8                	add    %ebx,%eax
}
80106e79:	5b                   	pop    %ebx
80106e7a:	5e                   	pop    %esi
80106e7b:	5f                   	pop    %edi
80106e7c:	5d                   	pop    %ebp
80106e7d:	c3                   	ret
80106e7e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e80:	8b 45 10             	mov    0x10(%ebp),%eax
80106e83:	85 c0                	test   %eax,%eax
80106e85:	74 31                	je     80106eb8 <walkpgdir+0x78>
80106e87:	e8 74 b8 ff ff       	call   80102700 <kalloc>
80106e8c:	89 c3                	mov    %eax,%ebx
80106e8e:	85 c0                	test   %eax,%eax
80106e90:	74 26                	je     80106eb8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106e92:	83 ec 04             	sub    $0x4,%esp
80106e95:	68 00 10 00 00       	push   $0x1000
80106e9a:	6a 00                	push   $0x0
80106e9c:	50                   	push   %eax
80106e9d:	e8 ce da ff ff       	call   80104970 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ea2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ea8:	83 c4 10             	add    $0x10,%esp
80106eab:	83 c8 07             	or     $0x7,%eax
80106eae:	89 06                	mov    %eax,(%esi)
80106eb0:	eb b8                	jmp    80106e6a <walkpgdir+0x2a>
80106eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ebb:	31 c0                	xor    %eax,%eax
}
80106ebd:	5b                   	pop    %ebx
80106ebe:	5e                   	pop    %esi
80106ebf:	5f                   	pop    %edi
80106ec0:	5d                   	pop    %ebp
80106ec1:	c3                   	ret
80106ec2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ec9:	00 
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ed0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ed0:	a1 c4 34 12 80       	mov    0x801234c4,%eax
80106ed5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eda:	0f 22 d8             	mov    %eax,%cr3
}
80106edd:	c3                   	ret
80106ede:	66 90                	xchg   %ax,%ax

80106ee0 <switchuvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
80106ee6:	83 ec 1c             	sub    $0x1c,%esp
80106ee9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106eec:	85 f6                	test   %esi,%esi
80106eee:	0f 84 cb 00 00 00    	je     80106fbf <switchuvm+0xdf>
  if(p->kstack == 0)
80106ef4:	8b 46 08             	mov    0x8(%esi),%eax
80106ef7:	85 c0                	test   %eax,%eax
80106ef9:	0f 84 da 00 00 00    	je     80106fd9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106eff:	8b 46 04             	mov    0x4(%esi),%eax
80106f02:	85 c0                	test   %eax,%eax
80106f04:	0f 84 c2 00 00 00    	je     80106fcc <switchuvm+0xec>
  pushcli();
80106f0a:	e8 11 d8 ff ff       	call   80104720 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f0f:	e8 8c cb ff ff       	call   80103aa0 <mycpu>
80106f14:	89 c3                	mov    %eax,%ebx
80106f16:	e8 85 cb ff ff       	call   80103aa0 <mycpu>
80106f1b:	89 c7                	mov    %eax,%edi
80106f1d:	e8 7e cb ff ff       	call   80103aa0 <mycpu>
80106f22:	83 c7 08             	add    $0x8,%edi
80106f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f28:	e8 73 cb ff ff       	call   80103aa0 <mycpu>
80106f2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f30:	ba 67 00 00 00       	mov    $0x67,%edx
80106f35:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f3c:	83 c0 08             	add    $0x8,%eax
80106f3f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f46:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f4b:	83 c1 08             	add    $0x8,%ecx
80106f4e:	c1 e8 18             	shr    $0x18,%eax
80106f51:	c1 e9 10             	shr    $0x10,%ecx
80106f54:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f5a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f65:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f71:	e8 2a cb ff ff       	call   80103aa0 <mycpu>
80106f76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f7d:	e8 1e cb ff ff       	call   80103aa0 <mycpu>
80106f82:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f86:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f8f:	e8 0c cb ff ff       	call   80103aa0 <mycpu>
80106f94:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f97:	e8 04 cb ff ff       	call   80103aa0 <mycpu>
80106f9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fa0:	b8 28 00 00 00       	mov    $0x28,%eax
80106fa5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fa8:	8b 46 04             	mov    0x4(%esi),%eax
80106fab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fb0:	0f 22 d8             	mov    %eax,%cr3
}
80106fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb6:	5b                   	pop    %ebx
80106fb7:	5e                   	pop    %esi
80106fb8:	5f                   	pop    %edi
80106fb9:	5d                   	pop    %ebp
  popcli();
80106fba:	e9 b1 d7 ff ff       	jmp    80104770 <popcli>
    panic("switchuvm: no process");
80106fbf:	83 ec 0c             	sub    $0xc,%esp
80106fc2:	68 ae 7b 10 80       	push   $0x80107bae
80106fc7:	e8 b4 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106fcc:	83 ec 0c             	sub    $0xc,%esp
80106fcf:	68 d9 7b 10 80       	push   $0x80107bd9
80106fd4:	e8 a7 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106fd9:	83 ec 0c             	sub    $0xc,%esp
80106fdc:	68 c4 7b 10 80       	push   $0x80107bc4
80106fe1:	e8 9a 93 ff ff       	call   80100380 <panic>
80106fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fed:	00 
80106fee:	66 90                	xchg   %ax,%ax

80106ff0 <inituvm>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ffc:	8b 75 10             	mov    0x10(%ebp),%esi
80106fff:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107002:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107005:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010700b:	77 49                	ja     80107056 <inituvm+0x66>
  mem = kalloc();
8010700d:	e8 ee b6 ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80107012:	83 ec 04             	sub    $0x4,%esp
80107015:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010701a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010701c:	6a 00                	push   $0x0
8010701e:	50                   	push   %eax
8010701f:	e8 4c d9 ff ff       	call   80104970 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107024:	58                   	pop    %eax
80107025:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010702b:	5a                   	pop    %edx
8010702c:	6a 06                	push   $0x6
8010702e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107033:	31 d2                	xor    %edx,%edx
80107035:	50                   	push   %eax
80107036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107039:	e8 82 fc ff ff       	call   80106cc0 <mappages>
  memmove(mem, init, sz);
8010703e:	83 c4 10             	add    $0x10,%esp
80107041:	89 75 10             	mov    %esi,0x10(%ebp)
80107044:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107047:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010704a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704d:	5b                   	pop    %ebx
8010704e:	5e                   	pop    %esi
8010704f:	5f                   	pop    %edi
80107050:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107051:	e9 aa d9 ff ff       	jmp    80104a00 <memmove>
    panic("inituvm: more than a page");
80107056:	83 ec 0c             	sub    $0xc,%esp
80107059:	68 ed 7b 10 80       	push   $0x80107bed
8010705e:	e8 1d 93 ff ff       	call   80100380 <panic>
80107063:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010706a:	00 
8010706b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107070 <loaduvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107079:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010707c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010707f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107085:	0f 85 a2 00 00 00    	jne    8010712d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010708b:	85 ff                	test   %edi,%edi
8010708d:	74 7d                	je     8010710c <loaduvm+0x9c>
8010708f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107090:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107093:	8b 55 08             	mov    0x8(%ebp),%edx
80107096:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107098:	89 c1                	mov    %eax,%ecx
8010709a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010709d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801070a0:	f6 c1 01             	test   $0x1,%cl
801070a3:	75 13                	jne    801070b8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801070a5:	83 ec 0c             	sub    $0xc,%esp
801070a8:	68 07 7c 10 80       	push   $0x80107c07
801070ad:	e8 ce 92 ff ff       	call   80100380 <panic>
801070b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070b8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070bb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801070c1:	25 fc 0f 00 00       	and    $0xffc,%eax
801070c6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070cd:	85 c9                	test   %ecx,%ecx
801070cf:	74 d4                	je     801070a5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801070d1:	89 fb                	mov    %edi,%ebx
801070d3:	b8 00 10 00 00       	mov    $0x1000,%eax
801070d8:	29 f3                	sub    %esi,%ebx
801070da:	39 c3                	cmp    %eax,%ebx
801070dc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070df:	53                   	push   %ebx
801070e0:	8b 45 14             	mov    0x14(%ebp),%eax
801070e3:	01 f0                	add    %esi,%eax
801070e5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801070e6:	8b 01                	mov    (%ecx),%eax
801070e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ed:	05 00 00 00 80       	add    $0x80000000,%eax
801070f2:	50                   	push   %eax
801070f3:	ff 75 10             	push   0x10(%ebp)
801070f6:	e8 b5 a9 ff ff       	call   80101ab0 <readi>
801070fb:	83 c4 10             	add    $0x10,%esp
801070fe:	39 d8                	cmp    %ebx,%eax
80107100:	75 1e                	jne    80107120 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107102:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107108:	39 fe                	cmp    %edi,%esi
8010710a:	72 84                	jb     80107090 <loaduvm+0x20>
}
8010710c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010710f:	31 c0                	xor    %eax,%eax
}
80107111:	5b                   	pop    %ebx
80107112:	5e                   	pop    %esi
80107113:	5f                   	pop    %edi
80107114:	5d                   	pop    %ebp
80107115:	c3                   	ret
80107116:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010711d:	00 
8010711e:	66 90                	xchg   %ax,%ax
80107120:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107128:	5b                   	pop    %ebx
80107129:	5e                   	pop    %esi
8010712a:	5f                   	pop    %edi
8010712b:	5d                   	pop    %ebp
8010712c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010712d:	83 ec 0c             	sub    $0xc,%esp
80107130:	68 88 7e 10 80       	push   $0x80107e88
80107135:	e8 46 92 ff ff       	call   80100380 <panic>
8010713a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107140 <allocuvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010714c:	85 f6                	test   %esi,%esi
8010714e:	0f 88 98 00 00 00    	js     801071ec <allocuvm+0xac>
80107154:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107156:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107159:	0f 82 a1 00 00 00    	jb     80107200 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010715f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107162:	05 ff 0f 00 00       	add    $0xfff,%eax
80107167:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010716c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010716e:	39 f0                	cmp    %esi,%eax
80107170:	0f 83 8d 00 00 00    	jae    80107203 <allocuvm+0xc3>
80107176:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107179:	eb 44                	jmp    801071bf <allocuvm+0x7f>
8010717b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107180:	83 ec 04             	sub    $0x4,%esp
80107183:	68 00 10 00 00       	push   $0x1000
80107188:	6a 00                	push   $0x0
8010718a:	50                   	push   %eax
8010718b:	e8 e0 d7 ff ff       	call   80104970 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107190:	58                   	pop    %eax
80107191:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107197:	5a                   	pop    %edx
80107198:	6a 06                	push   $0x6
8010719a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010719f:	89 fa                	mov    %edi,%edx
801071a1:	50                   	push   %eax
801071a2:	8b 45 08             	mov    0x8(%ebp),%eax
801071a5:	e8 16 fb ff ff       	call   80106cc0 <mappages>
801071aa:	83 c4 10             	add    $0x10,%esp
801071ad:	85 c0                	test   %eax,%eax
801071af:	78 5f                	js     80107210 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801071b1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071b7:	39 f7                	cmp    %esi,%edi
801071b9:	0f 83 89 00 00 00    	jae    80107248 <allocuvm+0x108>
    mem = kalloc();
801071bf:	e8 3c b5 ff ff       	call   80102700 <kalloc>
801071c4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071c6:	85 c0                	test   %eax,%eax
801071c8:	75 b6                	jne    80107180 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071ca:	83 ec 0c             	sub    $0xc,%esp
801071cd:	68 25 7c 10 80       	push   $0x80107c25
801071d2:	e8 d9 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801071d7:	83 c4 10             	add    $0x10,%esp
801071da:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071dd:	74 0d                	je     801071ec <allocuvm+0xac>
801071df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071e2:	8b 45 08             	mov    0x8(%ebp),%eax
801071e5:	89 f2                	mov    %esi,%edx
801071e7:	e8 14 fa ff ff       	call   80106c00 <deallocuvm.part.0>
    return 0;
801071ec:	31 d2                	xor    %edx,%edx
}
801071ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f1:	89 d0                	mov    %edx,%eax
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5f                   	pop    %edi
801071f6:	5d                   	pop    %ebp
801071f7:	c3                   	ret
801071f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ff:	00 
    return oldsz;
80107200:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107206:	89 d0                	mov    %edx,%eax
80107208:	5b                   	pop    %ebx
80107209:	5e                   	pop    %esi
8010720a:	5f                   	pop    %edi
8010720b:	5d                   	pop    %ebp
8010720c:	c3                   	ret
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107210:	83 ec 0c             	sub    $0xc,%esp
80107213:	68 3d 7c 10 80       	push   $0x80107c3d
80107218:	e8 93 94 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
8010721d:	83 c4 10             	add    $0x10,%esp
80107220:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107223:	74 0d                	je     80107232 <allocuvm+0xf2>
80107225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107228:	8b 45 08             	mov    0x8(%ebp),%eax
8010722b:	89 f2                	mov    %esi,%edx
8010722d:	e8 ce f9 ff ff       	call   80106c00 <deallocuvm.part.0>
      kfree(mem);
80107232:	83 ec 0c             	sub    $0xc,%esp
80107235:	53                   	push   %ebx
80107236:	e8 65 b2 ff ff       	call   801024a0 <kfree>
      return 0;
8010723b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010723e:	31 d2                	xor    %edx,%edx
80107240:	eb ac                	jmp    801071ee <allocuvm+0xae>
80107242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107248:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010724b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724e:	5b                   	pop    %ebx
8010724f:	5e                   	pop    %esi
80107250:	89 d0                	mov    %edx,%eax
80107252:	5f                   	pop    %edi
80107253:	5d                   	pop    %ebp
80107254:	c3                   	ret
80107255:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010725c:	00 
8010725d:	8d 76 00             	lea    0x0(%esi),%esi

80107260 <deallocuvm>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	8b 55 0c             	mov    0xc(%ebp),%edx
80107266:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107269:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010726c:	39 d1                	cmp    %edx,%ecx
8010726e:	73 10                	jae    80107280 <deallocuvm+0x20>
}
80107270:	5d                   	pop    %ebp
80107271:	e9 8a f9 ff ff       	jmp    80106c00 <deallocuvm.part.0>
80107276:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010727d:	00 
8010727e:	66 90                	xchg   %ax,%ax
80107280:	89 d0                	mov    %edx,%eax
80107282:	5d                   	pop    %ebp
80107283:	c3                   	ret
80107284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010728b:	00 
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 0c             	sub    $0xc,%esp
80107299:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010729c:	85 f6                	test   %esi,%esi
8010729e:	74 59                	je     801072f9 <freevm+0x69>
  if(newsz >= oldsz)
801072a0:	31 c9                	xor    %ecx,%ecx
801072a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072a7:	89 f0                	mov    %esi,%eax
801072a9:	89 f3                	mov    %esi,%ebx
801072ab:	e8 50 f9 ff ff       	call   80106c00 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072b6:	eb 0f                	jmp    801072c7 <freevm+0x37>
801072b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072bf:	00 
801072c0:	83 c3 04             	add    $0x4,%ebx
801072c3:	39 fb                	cmp    %edi,%ebx
801072c5:	74 23                	je     801072ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072c7:	8b 03                	mov    (%ebx),%eax
801072c9:	a8 01                	test   $0x1,%al
801072cb:	74 f3                	je     801072c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072dd:	50                   	push   %eax
801072de:	e8 bd b1 ff ff       	call   801024a0 <kfree>
801072e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072e6:	39 fb                	cmp    %edi,%ebx
801072e8:	75 dd                	jne    801072c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f0:	5b                   	pop    %ebx
801072f1:	5e                   	pop    %esi
801072f2:	5f                   	pop    %edi
801072f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072f4:	e9 a7 b1 ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
801072f9:	83 ec 0c             	sub    $0xc,%esp
801072fc:	68 59 7c 10 80       	push   $0x80107c59
80107301:	e8 7a 90 ff ff       	call   80100380 <panic>
80107306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730d:	00 
8010730e:	66 90                	xchg   %ax,%ax

80107310 <setupkvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	56                   	push   %esi
80107314:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107315:	e8 e6 b3 ff ff       	call   80102700 <kalloc>
8010731a:	85 c0                	test   %eax,%eax
8010731c:	74 5e                	je     8010737c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010731e:	83 ec 04             	sub    $0x4,%esp
80107321:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107323:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107328:	68 00 10 00 00       	push   $0x1000
8010732d:	6a 00                	push   $0x0
8010732f:	50                   	push   %eax
80107330:	e8 3b d6 ff ff       	call   80104970 <memset>
80107335:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107338:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010733b:	83 ec 08             	sub    $0x8,%esp
8010733e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107341:	8b 13                	mov    (%ebx),%edx
80107343:	ff 73 0c             	push   0xc(%ebx)
80107346:	50                   	push   %eax
80107347:	29 c1                	sub    %eax,%ecx
80107349:	89 f0                	mov    %esi,%eax
8010734b:	e8 70 f9 ff ff       	call   80106cc0 <mappages>
80107350:	83 c4 10             	add    $0x10,%esp
80107353:	85 c0                	test   %eax,%eax
80107355:	78 19                	js     80107370 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107357:	83 c3 10             	add    $0x10,%ebx
8010735a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107360:	75 d6                	jne    80107338 <setupkvm+0x28>
}
80107362:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107365:	89 f0                	mov    %esi,%eax
80107367:	5b                   	pop    %ebx
80107368:	5e                   	pop    %esi
80107369:	5d                   	pop    %ebp
8010736a:	c3                   	ret
8010736b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107370:	83 ec 0c             	sub    $0xc,%esp
80107373:	56                   	push   %esi
80107374:	e8 17 ff ff ff       	call   80107290 <freevm>
      return 0;
80107379:	83 c4 10             	add    $0x10,%esp
}
8010737c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010737f:	31 f6                	xor    %esi,%esi
}
80107381:	89 f0                	mov    %esi,%eax
80107383:	5b                   	pop    %ebx
80107384:	5e                   	pop    %esi
80107385:	5d                   	pop    %ebp
80107386:	c3                   	ret
80107387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010738e:	00 
8010738f:	90                   	nop

80107390 <kvmalloc>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107396:	e8 75 ff ff ff       	call   80107310 <setupkvm>
8010739b:	a3 c4 34 12 80       	mov    %eax,0x801234c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073a0:	05 00 00 00 80       	add    $0x80000000,%eax
801073a5:	0f 22 d8             	mov    %eax,%cr3
}
801073a8:	c9                   	leave
801073a9:	c3                   	ret
801073aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	83 ec 08             	sub    $0x8,%esp
801073b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073bc:	89 c1                	mov    %eax,%ecx
801073be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073c4:	f6 c2 01             	test   $0x1,%dl
801073c7:	75 17                	jne    801073e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073c9:	83 ec 0c             	sub    $0xc,%esp
801073cc:	68 6a 7c 10 80       	push   $0x80107c6a
801073d1:	e8 aa 8f ff ff       	call   80100380 <panic>
801073d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073dd:	00 
801073de:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801073e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801073e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801073ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801073f5:	85 c0                	test   %eax,%eax
801073f7:	74 d0                	je     801073c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801073f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073fc:	c9                   	leave
801073fd:	c3                   	ret
801073fe:	66 90                	xchg   %ax,%ax

80107400 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107409:	e8 02 ff ff ff       	call   80107310 <setupkvm>
8010740e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107411:	85 c0                	test   %eax,%eax
80107413:	0f 84 e9 00 00 00    	je     80107502 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010741c:	85 c9                	test   %ecx,%ecx
8010741e:	0f 84 b2 00 00 00    	je     801074d6 <copyuvm+0xd6>
80107424:	31 f6                	xor    %esi,%esi
80107426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010742d:	00 
8010742e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107430:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107433:	89 f0                	mov    %esi,%eax
80107435:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107438:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010743b:	a8 01                	test   $0x1,%al
8010743d:	75 11                	jne    80107450 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010743f:	83 ec 0c             	sub    $0xc,%esp
80107442:	68 74 7c 10 80       	push   $0x80107c74
80107447:	e8 34 8f ff ff       	call   80100380 <panic>
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107450:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107457:	c1 ea 0a             	shr    $0xa,%edx
8010745a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107460:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107467:	85 c0                	test   %eax,%eax
80107469:	74 d4                	je     8010743f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010746b:	8b 00                	mov    (%eax),%eax
8010746d:	a8 01                	test   $0x1,%al
8010746f:	0f 84 9f 00 00 00    	je     80107514 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107475:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107477:	25 ff 0f 00 00       	and    $0xfff,%eax
8010747c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010747f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107485:	e8 76 b2 ff ff       	call   80102700 <kalloc>
8010748a:	89 c3                	mov    %eax,%ebx
8010748c:	85 c0                	test   %eax,%eax
8010748e:	74 64                	je     801074f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107490:	83 ec 04             	sub    $0x4,%esp
80107493:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107499:	68 00 10 00 00       	push   $0x1000
8010749e:	57                   	push   %edi
8010749f:	50                   	push   %eax
801074a0:	e8 5b d5 ff ff       	call   80104a00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074a5:	58                   	pop    %eax
801074a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074ac:	5a                   	pop    %edx
801074ad:	ff 75 e4             	push   -0x1c(%ebp)
801074b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074b5:	89 f2                	mov    %esi,%edx
801074b7:	50                   	push   %eax
801074b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074bb:	e8 00 f8 ff ff       	call   80106cc0 <mappages>
801074c0:	83 c4 10             	add    $0x10,%esp
801074c3:	85 c0                	test   %eax,%eax
801074c5:	78 21                	js     801074e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074cd:	3b 75 0c             	cmp    0xc(%ebp),%esi
801074d0:	0f 82 5a ff ff ff    	jb     80107430 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801074d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074dc:	5b                   	pop    %ebx
801074dd:	5e                   	pop    %esi
801074de:	5f                   	pop    %edi
801074df:	5d                   	pop    %ebp
801074e0:	c3                   	ret
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801074e8:	83 ec 0c             	sub    $0xc,%esp
801074eb:	53                   	push   %ebx
801074ec:	e8 af af ff ff       	call   801024a0 <kfree>
      goto bad;
801074f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801074f4:	83 ec 0c             	sub    $0xc,%esp
801074f7:	ff 75 e0             	push   -0x20(%ebp)
801074fa:	e8 91 fd ff ff       	call   80107290 <freevm>
  return 0;
801074ff:	83 c4 10             	add    $0x10,%esp
    return 0;
80107502:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107509:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010750c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010750f:	5b                   	pop    %ebx
80107510:	5e                   	pop    %esi
80107511:	5f                   	pop    %edi
80107512:	5d                   	pop    %ebp
80107513:	c3                   	ret
      panic("copyuvm: page not present");
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	68 8e 7c 10 80       	push   $0x80107c8e
8010751c:	e8 5f 8e ff ff       	call   80100380 <panic>
80107521:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107528:	00 
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107530 <copyuvm_cow>:

// Compartilha as páginas 
pde_t*
copyuvm_cow(pde_t *pgdir, uint sz)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  

  if((d = setupkvm()) == 0)
80107539:	e8 d2 fd ff ff       	call   80107310 <setupkvm>
8010753e:	85 c0                	test   %eax,%eax
80107540:	0f 84 f1 00 00 00    	je     80107637 <copyuvm_cow+0x107>
80107546:	89 c7                	mov    %eax,%edi
    return 0;
    
  for(i = 0; i < sz; i += PGSIZE){
80107548:	8b 45 0c             	mov    0xc(%ebp),%eax
8010754b:	85 c0                	test   %eax,%eax
8010754d:	0f 84 9e 00 00 00    	je     801075f1 <copyuvm_cow+0xc1>
80107553:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107556:	8b 7d 08             	mov    0x8(%ebp),%edi
80107559:	31 db                	xor    %ebx,%ebx
8010755b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107560:	89 d8                	mov    %ebx,%eax
80107562:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107565:	8b 04 87             	mov    (%edi,%eax,4),%eax
80107568:	a8 01                	test   $0x1,%al
8010756a:	75 14                	jne    80107580 <copyuvm_cow+0x50>
    if((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
      panic("copyuvm_cow: pte should exist");
8010756c:	83 ec 0c             	sub    $0xc,%esp
8010756f:	68 a8 7c 10 80       	push   $0x80107ca8
80107574:	e8 07 8e ff ff       	call   80100380 <panic>
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107580:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107582:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107587:	c1 ea 0a             	shr    $0xa,%edx
8010758a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107590:	8d 8c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80107597:	85 c9                	test   %ecx,%ecx
80107599:	74 d1                	je     8010756c <copyuvm_cow+0x3c>
    if(!(*pte & PTE_P))
8010759b:	8b 01                	mov    (%ecx),%eax
8010759d:	a8 01                	test   $0x1,%al
8010759f:	0f 84 9e 00 00 00    	je     80107643 <copyuvm_cow+0x113>
      panic("copyuvm_cow: page not present");
      
    pa = PTE_ADDR(*pte);
801075a5:	89 c6                	mov    %eax,%esi
801075a7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);

    // Se a página é gravável, precisamos torná-la Read-Only e marcar COW
    if(flags & PTE_W) {
801075ad:	a8 02                	test   $0x2,%al
801075af:	75 5f                	jne    80107610 <copyuvm_cow+0xe0>
    flags = PTE_FLAGS(*pte);
801075b1:	25 ff 0f 00 00       	and    $0xfff,%eax
801075b6:	89 c2                	mov    %eax,%edx
        *pte &= ~PTE_W;
        *pte |= PTE_COW;
    }

    // Mapeia no filho apontando para o MESMO endereço físico (pa)
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
801075b8:	83 ec 08             	sub    $0x8,%esp
801075bb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075c0:	52                   	push   %edx
801075c1:	89 da                	mov    %ebx,%edx
801075c3:	56                   	push   %esi
801075c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075c7:	e8 f4 f6 ff ff       	call   80106cc0 <mappages>
801075cc:	83 c4 10             	add    $0x10,%esp
801075cf:	85 c0                	test   %eax,%eax
801075d1:	78 55                	js     80107628 <copyuvm_cow+0xf8>
      goto bad;
    }
    
    // Incrementa contador de referência da página física
    inc_ref(pa);
801075d3:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < sz; i += PGSIZE){
801075d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    inc_ref(pa);
801075dc:	56                   	push   %esi
801075dd:	e8 be b1 ff ff       	call   801027a0 <inc_ref>
  for(i = 0; i < sz; i += PGSIZE){
801075e2:	83 c4 10             	add    $0x10,%esp
801075e5:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
801075e8:	0f 82 72 ff ff ff    	jb     80107560 <copyuvm_cow+0x30>
801075ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  }
  
  // É necessário fazer flush do TLB do pai, pois alteramos suas permissões para Read-Only
  lcr3(V2P(pgdir)); 
801075f1:	8b 45 08             	mov    0x8(%ebp),%eax
801075f4:	05 00 00 00 80       	add    $0x80000000,%eax
801075f9:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  freevm(d);
  return 0;
}
801075fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ff:	89 f8                	mov    %edi,%eax
80107601:	5b                   	pop    %ebx
80107602:	5e                   	pop    %esi
80107603:	5f                   	pop    %edi
80107604:	5d                   	pop    %ebp
80107605:	c3                   	ret
80107606:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010760d:	00 
8010760e:	66 90                	xchg   %ax,%ax
        flags &= ~PTE_W; // Remove permissão de escrita
80107610:	89 c2                	mov    %eax,%edx
        *pte &= ~PTE_W;
80107612:	83 e0 fd             	and    $0xfffffffd,%eax
        flags &= ~PTE_W; // Remove permissão de escrita
80107615:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
        *pte |= PTE_COW;
8010761b:	80 cc 01             	or     $0x1,%ah
8010761e:	89 01                	mov    %eax,(%ecx)
        flags |= PTE_COW; // Marca como Copy-on-Write
80107620:	80 ce 01             	or     $0x1,%dh
        *pte |= PTE_COW;
80107623:	eb 93                	jmp    801075b8 <copyuvm_cow+0x88>
80107625:	8d 76 00             	lea    0x0(%esi),%esi
  freevm(d);
80107628:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010762b:	83 ec 0c             	sub    $0xc,%esp
8010762e:	57                   	push   %edi
8010762f:	e8 5c fc ff ff       	call   80107290 <freevm>
  return 0;
80107634:	83 c4 10             	add    $0x10,%esp
}
80107637:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010763a:	31 ff                	xor    %edi,%edi
}
8010763c:	5b                   	pop    %ebx
8010763d:	89 f8                	mov    %edi,%eax
8010763f:	5e                   	pop    %esi
80107640:	5f                   	pop    %edi
80107641:	5d                   	pop    %ebp
80107642:	c3                   	ret
      panic("copyuvm_cow: page not present");
80107643:	83 ec 0c             	sub    $0xc,%esp
80107646:	68 c6 7c 10 80       	push   $0x80107cc6
8010764b:	e8 30 8d ff ff       	call   80100380 <panic>

80107650 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107656:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107659:	89 c1                	mov    %eax,%ecx
8010765b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010765e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107661:	f6 c2 01             	test   $0x1,%dl
80107664:	0f 84 f8 00 00 00    	je     80107762 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010766a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010766d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107673:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107674:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107679:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107680:	89 d0                	mov    %edx,%eax
80107682:	f7 d2                	not    %edx
80107684:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107689:	05 00 00 00 80       	add    $0x80000000,%eax
8010768e:	83 e2 05             	and    $0x5,%edx
80107691:	ba 00 00 00 00       	mov    $0x0,%edx
80107696:	0f 45 c2             	cmovne %edx,%eax
}
80107699:	c3                   	ret
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 0c             	sub    $0xc,%esp
801076a9:	8b 75 14             	mov    0x14(%ebp),%esi
801076ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801076af:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076b2:	85 f6                	test   %esi,%esi
801076b4:	75 51                	jne    80107707 <copyout+0x67>
801076b6:	e9 9d 00 00 00       	jmp    80107758 <copyout+0xb8>
801076bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801076c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801076c6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801076cc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801076d2:	74 74                	je     80107748 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801076d4:	89 fb                	mov    %edi,%ebx
801076d6:	29 c3                	sub    %eax,%ebx
801076d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801076de:	39 f3                	cmp    %esi,%ebx
801076e0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801076e3:	29 f8                	sub    %edi,%eax
801076e5:	83 ec 04             	sub    $0x4,%esp
801076e8:	01 c1                	add    %eax,%ecx
801076ea:	53                   	push   %ebx
801076eb:	52                   	push   %edx
801076ec:	89 55 10             	mov    %edx,0x10(%ebp)
801076ef:	51                   	push   %ecx
801076f0:	e8 0b d3 ff ff       	call   80104a00 <memmove>
    len -= n;
    buf += n;
801076f5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801076f8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801076fe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107701:	01 da                	add    %ebx,%edx
  while(len > 0){
80107703:	29 de                	sub    %ebx,%esi
80107705:	74 51                	je     80107758 <copyout+0xb8>
  if(*pde & PTE_P){
80107707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010770a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010770c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010770e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107711:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107717:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010771a:	f6 c1 01             	test   $0x1,%cl
8010771d:	0f 84 46 00 00 00    	je     80107769 <copyout.cold>
  return &pgtab[PTX(va)];
80107723:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107725:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010772b:	c1 eb 0c             	shr    $0xc,%ebx
8010772e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107734:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010773b:	89 d9                	mov    %ebx,%ecx
8010773d:	f7 d1                	not    %ecx
8010773f:	83 e1 05             	and    $0x5,%ecx
80107742:	0f 84 78 ff ff ff    	je     801076c0 <copyout+0x20>
  }
  return 0;
}
80107748:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010774b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107750:	5b                   	pop    %ebx
80107751:	5e                   	pop    %esi
80107752:	5f                   	pop    %edi
80107753:	5d                   	pop    %ebp
80107754:	c3                   	ret
80107755:	8d 76 00             	lea    0x0(%esi),%esi
80107758:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010775b:	31 c0                	xor    %eax,%eax
}
8010775d:	5b                   	pop    %ebx
8010775e:	5e                   	pop    %esi
8010775f:	5f                   	pop    %edi
80107760:	5d                   	pop    %ebp
80107761:	c3                   	ret

80107762 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107762:	a1 00 00 00 00       	mov    0x0,%eax
80107767:	0f 0b                	ud2

80107769 <copyout.cold>:
80107769:	a1 00 00 00 00       	mov    0x0,%eax
8010776e:	0f 0b                	ud2
