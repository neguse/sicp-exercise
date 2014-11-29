#lang racket

; これが元のです
; (define (count-leaves x)
;   (cond ((null? x) 0)  
;         ((not (pair? x)) 1)
;         (else (+ (count-leaves (car x))
;                  (count-leaves (cdr x))))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) '() sequence))

(define (count-leaves t)
  (accumulate + 0 (map (lambda (x)
						 (cond 
						   ((null? x) 0)
						   ((pair? x) (count-leaves x))
						   (else x))) t)))

(count-leaves '(1 2 (3 4) 5))
; 15

; なんか力技な感じだなぁ
; http://www.billthelizard.com/2011/04/sicp-235-counting-leaves-of-tree.html
; あー、enumerate-tree使うんですか…そりゃあそっちの方が簡潔ですね
