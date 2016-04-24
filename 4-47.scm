
(define (require p)
  (if (not p) (amb)))

(define nouns '(noun student professor cat class))

(define verbs '(verb studies lectures eats sleeps))

(define articles '(article the a))

(define prepositions '(prep for to in by with))

(define (parse-sentence)
  (list 'sentence
		(parse-noun-phrase)
		(parse-verb-phrase)))

(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend (list 'noun-phrase
                             noun-phrase
                             (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

; これが元のやつ
;(define (parse-verb-phrase)
;  (define (maybe-extend verb-phrase)
;	(amb verb-phrase
;		 (maybe-extend (list 'verb-phrase
;							 verb-phrase
;							 (parse-prepositional-phrase)))))
;  (maybe-extend (parse-word verbs)))
(define (parse-verb-phrase)
  (amb (parse-word verbs)
       (list 'verb-phrase
             (parse-verb-phrase)
             (parse-prepositional-phrase))))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
	(set! *unparsed* (cdr *unparsed*))
	(list (car word-list) found-word)))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
		(parse-word prepositions)
		(parse-noun-phrase)))



(define *unparsed* '())

(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
	(require (null? *unparsed*))
	sent))

(parse '(the professor lectures to the student in the class with the cat))
try-again
try-again
try-again
try-again
try-again
try-again

; 動かしたら止まらなくなったでござる。
; http://www.serendip.ws/archives/2540
; うーん、まあ無限再帰になるよねーってことみたいだけど
; ambの実装わかってないのでいまいち理解できてない感がある

