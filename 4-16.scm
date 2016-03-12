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
  ; (display 'myeval)
  ; (display exp)
  ; (newline)
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
  ; (display 'myapply)
  ; (display procedure)
  ; (display arguments)
  ; (newline)
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

(define (eval-unbind exp env)
  (define-variable! (undefinition-variable exp)
					'()
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

(define (undefinition? exp)
  (tagged-list? exp 'unbind))

(define (undefinition-variable exp)
  (cadr exp))

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))
(define (make-define farg body)
  (cons 'define (cons farg body)))


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
  (list 'procedure parameters (scan-out-defines body) env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))


(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))


(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))
(define (next-of-frame frame) (cdr frame))
(define (end-of-frame? frame) (eq? 'end-of-frame (caar frame)))
(define (set-value-of-frame! frame value) (set-cdr! (car frame) value))
(define (first-variable-of-frame frame) (caar frame))
(define (first-value-of-frame frame) (cdar frame))

(define the-empty-environment '())

(define (make-frame variables values)
  (if
	(and (null? variables) (null? values))
	'((end-of-frame))
	(cons
	  (cons (car variables) (car values))
	  (make-frame (cdr variables) (cdr values)))))

(define (add-binding-to-frame! var val frame)
  (let
	((pcar (car frame)) (pcdr (cdr frame)))
	(set-car! frame (cons var val))
	(set-cdr! frame (cons pcar pcdr))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan frame)
      (cond ((end-of-frame? frame)
             (env-loop (enclosing-environment env)))
            ((eq? var (first-variable-of-frame frame))
			 (if (eq? (first-value-of-frame frame) '*unassigned*)
			   (error "Unassigned variable")
			   (first-value-of-frame frame)))
            (else (scan (next-of-frame frame)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan frame))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan frame)
      (cond ((end-of-frame? frame)
             (env-loop (enclosing-environment env)))
            ((eq? var (first-variable-of-frame frame))
             (set-value-of-frame! frame val))
            (else (scan (next-of-frame frame)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan frame))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan frame)
      (cond ((end-of-frame? frame)
             (add-binding-to-frame! var val frame))
            ((eq? var (first-variable-of-frame frame))
             (set-value-of-frame! frame val))
            (else (scan (next-of-frame frame)))))
    (scan frame)))

(define (scan-out-defines body)
  (define (is-define? exp)
	(and
	  (list? exp)
	  (eq? (car exp) 'define)))
  (define (scan-defines vars exps bodies body)
	(cond
	  ((null? body) (list (reverse vars) (reverse exps) (reverse bodies)))
	  ((is-define? (car body))
	   (scan-defines
		 (cons (definition-variable (car body)) vars)
		 (cons (definition-value (car body)) exps)
		 bodies
		 (cdr body)))
	  (else
		(scan-defines vars exps (cons (car body) bodies) (cdr body)))))
  (define (unassined-vars-exp vars)
	(if (null? vars)
	  '()
	  (cons (list (car vars) ''*unassigned*)
			(unassined-vars-exp (cdr vars)))))
  (define (set-vars-exp vars exps)
	(if (null? vars)
	  '()
	  (cons (list 'set! (car vars) (car exps))
			(set-vars-exp (cdr vars) (cdr exps)))))
  (define (make-define vars exps bodies)
	(if (null? vars)
	  bodies
	  (list (append
		(list 'let (unassined-vars-exp vars))
		(append (set-vars-exp vars exps) bodies)))))
  (apply make-define (scan-defines '() '() '() body)))

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
        (list 'eq? eq?)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)
        (list '< <)
        (list '> >)
        (list '= =)
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

(define (install-unbind)
  (put 'eval 'unbind eval-unbind)
  'done)
(install-unbind)

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

(define (while->combination exp)
  (define (while-cond exp)
	(cadr exp))
  (define (while-body exp)
	(cddr exp))
  (let ((while-sym (gensym)))
	(list
	  'begin
	  (make-define (list while-sym)
				   (list (list
					 'if
					 (while-cond exp)
					 (append (cons 'begin (while-body exp)) (list (list while-sym))))))
	  (list while-sym))))

(define (install-while)
  (define (eval-while exp env)
	(myeval (while->combination exp) env))
  (put 'eval 'while eval-while)
  'done)
(install-while)

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

(define (named-let? exp)
  (not (pair? (cadr exp))))

(define (nlet-var exp)
  (cadr exp))
(define (let-parameters exp)
  (cadr exp))
(define (nlet-parameters exp)
  (caddr exp))
(define (let-body exp)
  (cddr exp))
(define (nlet-body exp)
  (cdddr exp))

(define (let-parameters-vars params)
  (if (null? params) '()
	(cons (caar params) (let-parameters-vars (cdr params)))))
(define (let-parameters-exps params)
  (if (null? params) '()
	(cons (cadar params) (let-parameters-exps (cdr params)))))

(define (let->combination exp)
  (if (named-let? exp)

	;; named let
	(list
	  'begin
	  (make-define
		(cons (nlet-var exp) (let-parameters-vars (nlet-parameters exp)))
		(nlet-body exp))
	  (cons
		(nlet-var exp)
		(let-parameters-exps (nlet-parameters exp))))

	;; normal let
	(cons
	  (make-lambda
		(let-parameters-vars (let-parameters exp))
		(let-body exp))
	  (let-parameters-exps (let-parameters exp)))))

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

; test named let

(test-is
  (myeval '(let a ((x 1)) x) the-global-environment)
  1)
(test-is
  (myeval '(let b ((x 1) (y 2)) (+ x y)) the-global-environment)
  3)
(test-is
  (myeval '(let f ((x 0)) (if (eq? x 1) 2 (f 1))) the-global-environment)
  2)

; test let*
(test-is
  (myeval '(let* ((x 1) (y x)) (+ x y)) the-global-environment)
  2)
(test-is
  (myeval '(let* ((x 3) (y (+ x 2)) (z (+ x y 5))) (* x z)) the-global-environment)
  39)

; test while
(myeval '(define x 0) the-global-environment)
(test-is (myeval 'x the-global-environment) 0)
(test-is
  (myeval '(while (< x 3) (set! x (+ x 1)) x) the-global-environment)
  #f)
(test-is (myeval 'x the-global-environment) 3)

; test unbind
(myeval '(define x 0) the-global-environment)
(myeval '(unbind x) the-global-environment)
(test-is
  (myeval 'x the-global-environment)
  '())

; test scan-out-defines
(test-isequal
  (scan-out-defines '((define u e1)
					  (define v e2)
					  e3))
  '((let
	 ((u '*unassigned*)
	  (v '*unassigned*))
	 (set! u e1)
	 (set! v e2)
	 e3)))

(myeval '(define (iseven x)
		   (define (even? n)
			 (if (= n 0)
			   true
			   (odd? (- n 1))))
		   (define (odd? n)
			 (if (= n 0)
			   false
			   (even? (- n 1))))
		   (even? x)) the-global-environment)
(test-is
  (myeval '(iseven 0) the-global-environment) 'false)

(test-done)

; (driver-loop)

; おしいところまでは来たんだけど、引数が'()になってしまってる…

; たぶん、make-procedureに入れたほうがいいんだろうなぁという気がする。
; これは、getterで変換するとその度に変換が走るので非効率になりそうという理由から。

; あと、この方法だとdefine > 式 > define という順だとうまくいかない。

