#lang racket

(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (cdr mobile))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (cdr branch))

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

; right-branchとbranch-structureだけcadrからcdrに変えていけた。
; えらい。

