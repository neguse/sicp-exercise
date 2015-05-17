#lang racket

; a. 上でやったことを説明せよ. 述語number?やvariable?がデータ主導の振分けに吸収出来ないのはなぜか. 
; 「上でやったこと」というのは、もともとのderivのうち、「演算子+オペランド」の処理を型タグによる処理に置き換えたものである。
; number?やvariable?が吸収できないのは…演算子+オペランドという形式じゃないからじゃないかな

; b. 和と積の微分の手続きを書き, 上のプログラムで使う表に, それらを設定するのに必要な補助プログラムを書け. 
; これ、getとputの定義が無いと無理っぽいんですが…
; とりあえずやっつけでそれっぽいの作る。

(define global-table '())

(define (put op type item)
  (set! global-table
	(cons (list op type item) global-table)))

(define (get op type)
  (define (get-inner op type table)
	(if (and
		  (eq? (caar table) op)
		  (eq? (cadar table) type))
	  (caddar table)
	  (get-inner op type (cdr table))))
  (get-inner op type global-table))

(put 'a 'b 1)
(put 'a 'c 2)
(put 'b 'b 3)
(put 'b 'c 4)
(= (get 'a 'b) 1)
(= (get 'a 'c) 2)
(= (get 'b 'b) 3)
(= (get 'b 'c) 4)

; つくった。

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
	(car datum)
	(error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
	(cdr datum)
	(error "Bad tagged datum -- CONTENTS" datum)))

(define (deriv exp var)
  (cond ((number? exp) 0)
		((variable? exp) (if (same-variable? exp var) 1 0))
		(else ((get 'deriv (operator exp)) (operands exp)
										   var))))
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
		((=number? a2 0) a1)
		((and (number? a1) (number? a2)) (+ a1 a2))
		(else (list '+ a1 a2))))
(define (addend s) (car s))
(define (augend s) (cadr s))

(define (install-sum-package)
  (define (deriv-sum exp var)
	(make-sum (deriv (addend exp) var)
			  (deriv (augend exp) var)))
  (put 'deriv '+ deriv-sum)
  'done)

(install-sum-package)


(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
		((=number? m1 1) m2)
		((=number? m2 1) m1)
		((and (number? m1) (number? m2)) (* m1 m2))
		(else (list '* m1 m2))))
(define (multiplier p) (car p))
(define (multiplicand p) (cadr p))

(define (install-product-package)
  (define (deriv-product exp var)
	(make-sum
	  (make-product (multiplier exp)
					(deriv (multiplicand exp) var))
	  (make-product (deriv (multiplier exp) var)
					(multiplicand exp))))
  (put 'deriv '* deriv-product)
  'done)

(install-product-package)


(deriv '(+ x 3) 'x)
; '(+ 1 0)
(deriv '(* x y) 'x)
; '(+ (* x 0) (* 1 y))
(deriv '(* (* x y) (+ x 3)) 'x)
; '(+ (* (* x y) (+ 1 0)) (* (+ (* x 0) (* 1 y)) (+ x 3)))

; うーん、これでいいのか…

; c. (問題2.56)のべき乗のような, その他の微分規則を選び, このデータ主導システムに設定せよ. 
; これは、まあ2.56の解答からそれっぽく持ってくればいいわけですよね。


(define (make-exponentiation b e)
  (cond ((=number? e 0) 1)
		((=number? e 1) b)
		(else (list '** b e))))
(define (base e) (car e))
(define (exponent e) (cadr e))
(define (install-exponential-package)
  (define (deriv-exponential exp var)
	(make-product (make-product
					(exponent exp)
					(make-exponentiation (base exp) (make-sum (exponent exp) -1)))
				  (deriv (base exp) var)))
  (put 'deriv '** deriv-exponential)
  'done)

(install-exponential-package)

(deriv '(** x 2) 'x)
; '(* (* 2 (** x (+ 2 -1))) 1)

; はい。

; d. この代数式操作では, 式の型はそれを結合している代数演算である. しかし手続きの目印を反対にし, derivの振分けを
; ((get (operator exp) 'deriv) (operands exp) var)
; のようにしたとしよう. 微分システムには対応したどのような変更が必要か. 

; 微分システムというよりは、install-の処理に変更が必要なだけで、
; それ以外は変更いらないんじゃないかなぁ。

