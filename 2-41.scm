#lang racket

(define (prime? n)
  (let ((m (sqrt n)))
    (let loop ((i 2))
      (or (< m i)
          (and (not (zero? (modulo n i)))
               (loop (+ i (if (= i 2) 1 2))))))))

(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (unique-pairs n)
  (flatmap (lambda (i)
			 (map (lambda (j) (list i j))
				  (enumerate-interval 1 (- i 1))))
		   (enumerate-interval 1 n)))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum? (unique-pairs n))))

(define (permutations s)
  (if (null? s)                    ; 空集合?
      '()                          ; 空集合を含むリスト
      (flatmap (lambda (x)
                 (map (lambda (p) (cons x p))
                      (permutations (remove x s))))
               s)))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(define (threes n)
  (flatmap (lambda (i)
			 (flatmap (lambda (j) 
						(map (lambda (k)
								   (list i j k))
								 (enumerate-interval 1 j)))
						(enumerate-interval 1 i)))
		   (enumerate-interval 1 n)))

(define (threes-sum-eq n s)
  (filter (lambda (x) (= s (accumulate + 0 x))) (threes n)))

(threes 3)
; '((1 1 1) (2 1 1) (2 2 1) (2 2 2) (3 1 1) (3 2 1) (3 2 2) (3 3 1) (3 3 2) (3 3 3))
(threes-sum-eq 3 5)
; '((2 2 1) (3 1 1))
; よし。
