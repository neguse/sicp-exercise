
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

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
	(amb verb-phrase
		 (maybe-extend (list 'verb-phrase
							 verb-phrase
							 (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))

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


;	1
;	(sentence
;	  (simple-noun-phrase
;		(article the)
;		(noun professor))
;	  (verb-phrase
;		(verb-phrase
;		  (verb-phrase
;			(verb lectures)
;			(prep-phrase
;			  (prep to)
;			  (simple-noun-phrase
;				(article the)
;				(noun student))))
;		  (prep-phrase
;			(prep in)
;			(simple-noun-phrase
;			  (article the)
;			  (noun class))))
;		(prep-phrase
;		  (prep with)
;		  (simple-noun-phrase
;			(article the)
;			(noun cat)))))
;	教授, 学生に教える, 教室で, 猫と
;	
;	2
;	(sentence
;	  (simple-noun-phrase
;		(article the)
;		(noun professor))
;	  (verb-phrase
;		(verb-phrase
;		  (verb lectures)
;		  (prep-phrase
;			(prep to)
;			(simple-noun-phrase
;			  (article the)
;			  (noun student))))
;		(prep-phrase
;		  (prep in)
;		  (noun-phrase
;			(simple-noun-phrase
;			  (article the)
;			  (noun class))
;			(prep-phrase
;			  (prep with)
;			  (simple-noun-phrase
;				(article the)
;				(noun cat)))))))
;	教授, 学生に教える, 猫のいる教室で
;	3
;	(sentence
;	  (simple-noun-phrase
;		(article the)
;		(noun professor))
;	  (verb-phrase
;		(verb-phrase
;		  (verb lectures)
;		  (prep-phrase
;			(prep to)
;			(noun-phrase
;			  (simple-noun-phrase
;				(article the)
;				(noun student))
;			  (prep-phrase
;				(prep in)
;				(simple-noun-phrase
;				  (article the)
;				  (noun class))))))
;		(prep-phrase
;		  (prep with)
;		  (simple-noun-phrase
;			(article the)
;			(noun cat)))))
;	教授, 教室にいる学生に教える, 猫と
;
;	4
;	(sentence
;	  (simple-noun-phrase
;		(article the)
;		(noun professor))
;	  (verb-phrase
;		(verb lectures)
;		(prep-phrase
;		  (prep to)
;		  (noun-phrase
;			(noun-phrase
;			  (simple-noun-phrase
;				(article the)
;				(noun student))
;			  (prep-phrase
;				(prep in)
;				(simple-noun-phrase
;				  (article the)
;				  (noun class))))
;			(prep-phrase
;			  (prep with)
;			  (simple-noun-phrase
;				(article the)
;				(noun cat)))))))
;	教授, 教える, 教室にいる学生と猫に
;	
;	5
;	(sentence
;	  (simple-noun-phrase
;		(article the)
;		(noun professor))
;	  (verb-phrase
;		(verb lectures)
;		(prep-phrase
;		  (prep to)
;		  (noun-phrase
;			(simple-noun-phrase
;			  (article the)
;			  (noun student))
;			(prep-phrase
;			  (prep in)
;			  (noun-phrase
;				(simple-noun-phrase
;				  (article the)
;				  (noun class))
;				(prep-phrase
;				  (prep with)
;				  (simple-noun-phrase
;					(article the)
;					(noun cat)))))))))
;	教授, 教える, 猫のいる教室にいる学生に
;	
; あんまり自信ない…
