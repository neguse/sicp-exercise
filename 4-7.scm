#lang racket

(require r5rs)
(require "test.scm")

; put, get

(define global-table '())

(define (put op type item)
  (set! global-table
	(cons (list op type item) global-table)))

(define (get op type)
  (define (get-inner op type table)
	(cond
	  ((null? table) '())
	  ((and
		 (eq? (caar table) op)
		 (eq? (cadar table) type))
	   (caddar table))
	  (else (get-inner op type (cdr table)))))
  (get-inner op type global-table))

; attach

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

(define (installed-exp? exp)
  (not (null? (get 'eval (type-tag exp)))))


;;;;METACIRCULAR EVALUATOR FROM CHAPTER 4 (SECTIONS 4.1.1-4.1.4) of
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch4.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;Then you can initialize and start the evaluator by evaluating
;;;; the two commented-out lines at the end of the file (setting up the
;;;; global environment and starting the driver loop).

;;;;**WARNING: Don't load this file twice (or you'll lose the primitives
;;;;  interface, due to renamings of apply).

;;;from section 4.1.4 -- must precede def of metacircular apply
;;(define apply-in-underlying-scheme apply)

;;;SECTION 4.1.1

(define (myeval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
		((installed-exp? exp)
		 ((get 'eval (type-tag exp)) exp env))
		((application? exp)
		 (myapply (myeval (operator exp) env)
				 (list-of-values (operands exp) env)))
		(else
		  (error "Unknown expression type -- EVAL" exp))))

(define (myapply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))


(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (myeval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (myeval (if-predicate exp) env))
      (myeval (if-consequent exp) env)
      (myeval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (myeval (first-exp exps) env))
        (else (myeval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (myeval (assignment-value exp) env)
                       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (myeval (definition-value exp) env)
                    env)
  'ok)

;;;SECTION 4.1.2

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (variable? exp) (symbol? exp))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))


(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))


(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))


(define (begin? exp) (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))


(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))


(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond-test-clause? clause)
  (and
	(pair? clause)
	(pair? (cdr clause))
	(eq? (cadr clause) '=>)))

(define (cond-test-test clause)
  (car clause))

(define (cond-test-recipient clause)
  (cddr clause))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false                          ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
		(cond
		  ((cond-else-clause? first)
		   (if (null? rest)
			 (sequence->exp (cond-actions first))
			 (error "ELSE clause isn't last -- COND->IF" clauses)))
		  ((cond-test-clause? first)
		   (make-if (cond-test-test first)
					(sequence->exp (cond-test-recipient first))
					(expand-clauses rest)))
		  (else
			(make-if (cond-predicate first)
					 (sequence->exp (cond-actions first))
					 (expand-clauses rest)))))))

;;;SECTION 4.1.3

(define (true? x)
  (not (eq? x false)))

(define (false? x)
  (eq? x false))


(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))


(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))


(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

;;;SECTION 4.1.4

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

;[do later] (define the-global-environment (setup-environment))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)
;;      more primitives
        ))

(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

;[moved to start of file] (define apply-in-underlying-scheme apply)

(define (apply-primitive-procedure proc args)
  (apply
   (primitive-implementation proc) args))



(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (myeval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

;;;Following are commented out so as not to be evaluated when
;;; the file is loaded.
(define the-global-environment (setup-environment))

'METACIRCULAR-EVALUATOR-LOADED

(define (install-assignment)
  (put 'eval 'set! eval-assignment)
  'done)
(install-assignment)

(define (install-definition)
  (put 'eval 'define eval-definition)
  'done)
(install-definition)

(define (install-if)
  (put 'eval 'if eval-if)
  'done)
(install-if)


(define (install-lambda)
  (define (eval-lambda exp env)
	(make-procedure (lambda-parameters exp)
					(lambda-body exp)
					env))
  (put 'eval 'lambda eval-lambda)
  'done)
(install-lambda)

(define (install-begin)
  (define (eval-begin exp env)
	(eval-sequence (begin-actions exp) env))
  (put 'eval 'begin eval-begin)
  'done)
(install-begin)

(define (install-cond)
  (define (eval-cond exp env)
	(myeval (cond->if exp) env))
  (put 'eval 'cond eval-cond)
  'done)
(install-cond)

(define (eval-sequence-while c exps env)
  (let ((first-exp-value (myeval (first-exp exps) env)))
	(cond
	  ((last-exp? exps)
	   first-exp-value)
	  ((and (eq? c 'true) (not first-exp-value))
	   first-exp-value)
	  ((and (eq? c 'false) first-exp-value)
	   first-exp-value)
	  (else (eval-sequence-while c (rest-exps exps) env)))))

(define (install-and)
  (define (eval-and exp env)
	(eval-sequence-while 'true (begin-actions exp) env))
  (put 'eval 'and eval-and)
  'done)
(install-and)

(define (install-or)
  (define (eval-or exp env)
	(eval-sequence-while 'false (begin-actions exp) env))
  (put 'eval 'or eval-or)
  'done)
(install-or)

(define (let-parameters exp)
  (cadr exp))
(define (let-body exp)
  (cddr exp))

(define (let-parameters-vars params)
  (if (null? params) '()
	(cons (caar params) (let-parameters-vars (cdr params)))))
(define (let-parameters-exps params)
  (if (null? params) '()
	(cons (cadar params) (let-parameters-exps (cdr params)))))

(define (let->combination exp)
  (cons
	(make-lambda
	  (let-parameters-vars (let-parameters exp))
	  (let-body exp))
	(let-parameters-exps (let-parameters exp))))

(define (install-let)
  (define (eval-let exp env)
	(myeval (let->combination exp) env))
  (put 'eval 'let eval-let)
  'done)
(install-let)

(define (let*->nested-lets exp)
  (define (make-let1 var exp body)
	(list
	  'let
	  (list (list var exp))
	  body))
  (define (f params body)
	(if (null? params)
	  body
	  (let
		((var-head (caar params))
		 (exp-head (cadar params)))
		(make-let1 var-head exp-head (f (cdr params) body)))))
  (f (let-parameters exp) (caddr exp)))

(define (install-let*)
  (define (eval-let* exp env)
	(myeval (let*->nested-lets exp) env))
  (put 'eval 'let* eval-let*)
  'done)
(install-let*)

; test arith
(test-is
  (myeval '(+ 1 2) the-global-environment)
  3)

; test if
(test-is
  (myeval '(if true 0 1) the-global-environment)
  0)
(test-is
  (myeval '(if false 0 1) the-global-environment)
  1)

; test cond
(test-is
  (myeval '(cond (else 1)) the-global-environment)
  1)
(test-is
  (myeval '(cond (true 1) (else 2)) the-global-environment)
  1)
(test-is
  (myeval '(cond (false 1) (else 2)) the-global-environment)
  2)
(test-is
  (myeval '(cond (false 1)) the-global-environment)
  #f)
(test-is
  (myeval '(cond (true => 1) (else 2)) the-global-environment)
  1)
(test-is
  (myeval '(cond (false => 1) (else 2)) the-global-environment)
  2)

; test let
(test-is
  (myeval '(let ((x 1)) x) the-global-environment)
  1)
(test-is
  (myeval '(let ((x 1) (y 2)) (+ x y)) the-global-environment)
  3)

; test let*
(test-is
  (myeval '(let* ((x 1) (y x)) (+ x y)) the-global-environment)
  2)
(test-is
  (myeval '(let* ((x 3) (y (+ x 2)) (z (+ x y 5))) (* x z)) the-global-environment)
  39)

(test-done)

; (driver-loop)

; うーん、let*の方だけbodyの部分をcaddrにしないといけないのがよくわからない…

