
; エイトクイーン、2.42で解いてるんだけど
; もう一年以上前なのよね…
; ということで、もう一度ちゃんと考えてみる

(define (require p)
  (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-element-without items without)
  (require (not (null? items)))
  (if (eq? (car items) without)
	(an-element-without (cdr items) without)
	(amb (car items) (an-element-without (cdr items) without))))

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

(define (length l)
  (define (length-in l s)
	(if (null? l) s
	  (length-in (cdr l) (+ s 1))))
  (length-in l 0))

(define (in ypos board)
  (cond
	((null? board) false)
	((eq? ypos (car board)) true)
	(else (in ypos (cdr board)))))

(define (cross ypos board)
  (define (cross-in ypos xoff board)
	(cond
	  ((null? board) false)
	  ((or (eq? (- ypos xoff) (car board))
		   (eq? (+ ypos xoff) (car board)))
	   true)
	  (else (cross-in ypos (+ xoff 1) (cdr board)))))
  (cross-in ypos 1 board))

(define (safe? ypos board)
  (and
	(not (in ypos board))
	(not (cross ypos board))))
  
(define (amb-board size)
  (define (amb-board-in board)
	(if (eq? (length board) size)
	  board
	  (let ((xnext (an-integer-between 1 size)))
		(require (safe? xnext board))
		(amb-board-in (cons xnext  board)))))
  (amb-board-in '()))

(amb-board 8)

try-again
try-again
; ...

; もともとのScheme処理系にあったデバッガがつかえないので
; デバッグしんどいなあ
; あと、try-againを何度もやるのコピペだときついので
; それやる機能ほしい

