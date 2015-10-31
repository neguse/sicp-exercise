
; 同じ順番でacquireすれば、依存関係が循環しないので大丈夫なんですね。
; という説明で大丈夫なんだろうか…

(define (lesser-account a1 a2)
  (let ((i1 (a1 'id)) (i2 (a2 'id)))
	(if (< i1 i2) a1 a2)))
(define (bigger-account a1 a2)
  (let ((i1 (a1 'id)) (i2 (a2 'id)))
	(if (>= i1 i2) a1 a2)))

(define (serialized-exchange account1 account2)
  (let ((account1 (lesser-account account1 account2)) ((account2 (bigger-account account1 account2))))
	(let ((serializer1 (account1 'serializer))
		  (serializer2 (account2 'serializer)))
	  ((serializer1 (serializer2 exchange)) account1 account2))))

; うーん、serialized-exchangeには手を入れずに
; ソートして渡すラッパ作ったほうがいいかも。
; idはなんか適当にやってください。

