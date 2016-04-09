
; うーん、探索順の問題なんでしょうか。
; kだけどんどんiterateしてしまって答えなきところを延々と見てる気がする。
; これをなんとかするには、ambとはいえ探索順考えないとだめっすよというところをちゃんとやればいいと思う。

(define (require p)
  (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

(define (a-pythagorean-triple)
  (let ((k (an-integer-starting-from 1)))
	(let ((i (an-integer-between 1 k)))
	  (let ((j (an-integer-between 1 i)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))

(a-pythagorean-triple)

try-again
try-again
try-again
try-again
try-again

; はい。
