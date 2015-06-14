#lang racket

; Louis Reasonerは, apply-genericは引数が既に同じ型を持っていても, 互いの型へ強制変換を試みるべきだと考えた.
; a. apply-genericが型scheme-numberの二つの引数や型complexの二つの引数で, これらの型で表に見つからない手続きに対して呼び出されると, 何が起きるか.

; うーん、答え見てしまったんだけど、
; 無限再帰になってしまうらしい…

; なるほど、apply-genericは型変換をした後に自身を再帰呼び出しするから…
; ははあ

; b. うーん、だめなんじゃないかな。
; 型変換すべきでないならそこで再帰を停止しないといけない。

; c. 二つの引数が同じ型を持っていれば, 強制型変換を試みないように, apply-genericを修正せよ. 


(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
	(let ((proc (get op type-tags)))
	  (if proc
		(apply proc (map contents args))
		(if (= (length args) 2)
		  (let ((type1 (car type-tags))
				(type2 (cadr type-tags))
				(a1 (car args))
				(a2 (cadr args)))
			(let ((t1->t2 (get-coercion type1 type2))
				  (t2->t1 (get-coercion type2 type1)))
			  (cond ((eq? type1 type2)
					 (error "No method for these types"
							(list op type-tags)))
					(t1->t2
					  (apply-generic op (t1->t2 a1) a2))
					(t2->t1
					  (apply-generic op a1 (t2->t1 a2)))
					(else
					  (error "No method for these types"
							 (list op type-tags))))))
		  (error "No method for these types"
				 (list op type-tags)))))))

; 適当だけど、こんなんでいいんじゃないかな。
