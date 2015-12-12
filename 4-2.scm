#lang racket

; evalの定義はこれ
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
		((variable? exp) (lookup-variable-value exp env))
		((quoted? exp) (text-of-quotation exp))
		((assignment? exp) (eval-assignment exp env))
		((definition? exp) (eval-definition exp env))
		((if? exp) (eval-if exp env))
		((lambda? exp)
		 (make-procedure (lambda-parameters exp)
						 (lambda-body exp)
						 env))
		((begin? exp) 
		 (eval-sequence (begin-actions exp) env))
		((cond? exp) (eval (cond->if exp) env))
		((application? exp)
		 (apply (eval (operator exp) env)
				(list-of-values (operands exp) env)))
		(else
		  (error "Unknown expression type -- EVAL" exp))))

; eval-assignmentはこれ
(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
					   (eval (assignment-value exp) env)
					   env)
  'ok)

(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

; evalを再帰呼出ししているので、
; なんとなくやばいんじゃないの?という気はするけど
; よくわからん…

; https://wqzhang.wordpress.com/2009/09/14/sicp-exercise-4-2/
(define (application? exp) (pair? exp))

; あっ…これはだめですよ

(define (application? exp) (car exp))

(define (application-call? exp)
  (tagged-list? exp 'call))

; こんな感じでワークアラウンドしておいてください。
; その他のは適当に…

