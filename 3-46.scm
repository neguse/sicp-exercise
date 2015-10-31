
(define (make-mutex)
  (let ((cell (list false)))            
	(define (the-mutex m)
	  (cond ((eq? m 'acquire)
			 (if (test-and-set! cell)
			   (the-mutex 'acquire))) ; retry
			((eq? m 'release) (clear! cell))))
	the-mutex))

(define (test-and-set! cell)
  (if (car cell)
	true
	(begin (set-car! cell true)
		   false)))

; たとえば2つのPが同時にacquireしようとして、
; > (if (car cell)
; の部分がfalseを返してelse節を実行しようとして
; > (set-car! cell true)
; をどっちのPも実行してしまって、排他されない、ということが
; 起こりうるんですよ!まったく!

