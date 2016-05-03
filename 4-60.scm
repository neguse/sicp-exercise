
(assert! (rule (lives-near ?person-1 ?person-2)
			   (and (address ?person-1 (?town . ?rest-1))
					(address ?person-2 (?town . ?rest-2))
					(not (same ?person-1 ?person-2)))))

(lives-near ?person (Hacker Alyssa P))

; なんで二回でるか?
; わからん…というか、
; 同じレコードですら2回でてるんですけど…
; ;;; Query results:
; (lives-near (Hacker Alyssa P) (Fect Cy D))
; (lives-near (Hacker Alyssa P) (Fect Cy D))

; たぶん、問題文のやつはlives-near?の2個の変数が
; どちらもマッチしてしまうからで、
; person-1とperson-2の名前を辞書順で比較とかしてあげればいい気がする。

; で、同じ並びが2回表示されてしまうのはたぶんなんかのバグじゃないかなぁ。

