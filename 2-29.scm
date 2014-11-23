#lang racket

; あー、なんかこれ難しそうですね。

; モービルは、左右の枝からなる
; 枝は、長さと、stuructureからなる
; 長さは、単なる数値である
; structureは、「錘ないしモービル」である
; 錘は、単なる数である

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cadr mobile))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (cadr branch))

; あと、structureがどっちか判定するためのpredが必要っぽい

; #t -> structure is weight
; #f -> structure is mobile
(define (structure-is-weight? structure)
  (not (pair? structure)))

(define (total-weight structure)
  (if (structure-is-weight? structure)
	structure
	(+
	  (total-weight (branch-structure (left-branch structure)))
	  (total-weight (branch-structure (right-branch structure))))))

; テストデータだけBillさんの使わせてもらう
(define a (make-mobile (make-branch 2 3) (make-branch 2 3)))
(define b (make-mobile (make-branch 2 3) (make-branch 4 5)))
(define c (make-mobile (make-branch 5 a) (make-branch 3 b)))

(total-weight a)
; 6
(total-weight b)
; 8
(total-weight c)
; 14

; ここまではよし。

(define (torque branch)
  (*
	(branch-length branch)
	(total-weight (branch-structure branch))))

(define (balanced? structure)
  (if (structure-is-weight? structure)
	#t
	(and
	  (balanced? (branch-structure (left-branch structure)))
	  (balanced? (branch-structure (right-branch structure)))
	  (=
		(torque (left-branch structure))
		(torque (right-branch structure))))))

(balanced? a)
; #t
(balanced? b)
; #f
(balanced? c)
; #f

(define d (make-mobile (make-branch 10 a) (make-branch 12 5)))
(balanced? d)
; #t

; よし。
