#lang racket

; なんとなく、重複を許す方がめんどくさい気がするなぁ

; とりあえずelement-of-set?は同じ、と
(define (element-of-set? x set)
  (cond ((null? set) false)
		((equal? x (car set)) true)
		(else (element-of-set? x (cdr set)))))

; adjoin-setは、たぶんチェックせずに突っ込むだけでOKなんだろうなぁ
(define (adjoin-set x set)
  (cons x set))

; intersection-setについても、まあ同じで動くんじゃないかなぁ
; 同じ要素がある分だけ何度も走査することになって無駄っぽいけど
(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)        
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

; union-setもadjoin-setと同じで、くっつけるだけだよね
(define (union-set set1 set2)
  (append set1 set2))

(element-of-set? 1 '(1 2 2 1 3 1))
; #t
(element-of-set? 4 '(1 2 2 1 3 1))
; #f

(adjoin-set 1 '(2 3 3 2 1))
; '(1 2 3 3 2 1)

(intersection-set '(1 2 2 3 2 4) '(3 2 2 1 5 5))
; '(1 2 2 3 2)
(union-set '(1 2 2 3 2 4) '(3 2 2 1 5 5))
; '(1 2 2 3 2 4 3 2 2 1 5 5)

; よし。
