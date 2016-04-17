
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

(define (distinct? items)
  (cond ((null? items) true)
		((null? (cdr items)) true)
		((member (car items) (cdr items)) false)
		(else (distinct? (cdr items)))))

(define (xor a b)
  (or (and a (not b)) (and (not a) b)))

; fathers: moore downing hall barnacle parker
; daughters: mary gabrielle lorna rosalind melissa 

(define daughters '(mary gabrielle lorna rosalind melissa))

(define (or5 c1 c2 c3 c4 c5)
  (or c1 (or c2 (or c3 (or c4 c5)))))

(define (ans)
  (let ((moore-d (amb 'mary))
		(downing-d (an-element-of daughters))
		(hall-d (an-element-of daughters))
		(barnacle-d (amb 'melissa))
		(parker-d (an-element-of daughters)))
	(let ((moore-y (amb 'lorna))
		(downing-y (amb 'melissa))
		(hall-y (amb 'rosalind))
		(barnacle-y (amb 'gabrielle))
		(parker-y (an-element-without daughters parker-d)))
	(require
	  (distinct? (list moore-d downing-d hall-d barnacle-d parker-d)))
	(require
	  (distinct? (list moore-y downing-y hall-y barnacle-y parker-y)))

	; (require (= (barnacle-y 'gabrielle)))
	; (require (= (moore-y 'lorna)))
	; (require (= (hall-y 'rosalind)))
	; (require (= (downing-y 'melissa)))
	; (require (= (barnacle-d 'melissa)))

	; `Gabrielleの父親はParker博士の娘の名前をつけたヨットを持っている.`
	; を言い換えると、`gabrielを娘に持つならばparkerの娘の名前のヨットを持つ`
	; となる。
	; これは一個ずつ試してorでつなぐしかない気がする。
	(require (or5
			   (and (eq? moore-d 'gabrielle) (eq? moore-y parker-d))
			   (and (eq? downing-d 'gabrielle) (eq? downing-y parker-d))
			   (and (eq? hall-d 'gabrielle) (eq? hall-y parker-d))
			   (and (eq? barnacle-d 'gabrielle) (eq? barnacle-y parker-d))
			   (and (eq? parker-d 'gabrielle) (eq? parker-y parker-d))))
	(list (list 'moore moore-d)
		  (list 'downing downing-d)
		  (list 'hall hall-d)
		  (list 'barnacle barnacle-d)
		  (list 'parker parker-d)))))

(ans)
try-again
try-again
try-again
try-again
try-again

; ((moore mary) (downing lorna) (hall gabrielle) (barnacle melissa) (parker rosalind))
; ということで、lornaの父はdowning!

; ((moore mary) (downing lorna) (hall gabrielle) (barnacle melissa) (parker rosalind))
; ((moore gabrielle) (downing mary) (hall rosalind) (barnacle melissa) (parker lorna))
; ((moore gabrielle) (downing rosalind) (hall mary) (barnacle melissa) (parker lorna))
; ((moore lorna) (downing mary) (hall gabrielle) (barnacle melissa) (parker rosalind))
; の4パターン!
; …と思ったけど、他の人だと2パターンって言ってるなあ…

; 効率よくする工夫は、ambの引数を絞るところしかやってないんだけど
; それしないと終わらないぐらい遅かった。 
; それしただけで大丈夫になったので、そんなもんかーという感じ。
; あと、letってインデントだめになりがちなので
; go fmtみたいなS式フォーマッタがほしい。

