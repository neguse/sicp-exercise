
; これがもとのやつ
; (rule (outranked-by ?staff-person ?boss)
;       (or (supervisor ?staff-person ?boss)
;           (and (supervisor ?staff-person ?middle-manager)
;                (outranked-by ?middle-manager ?boss))))

; これが書き直したやつ
(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (outranked-by ?middle-manager ?boss)
               (supervisor ?staff-person ?middle-manager))))

; andをマッチするときは、左から順番にフィルタしていくという話があったのだけど、
; supervisor とマッチするより先に再帰的にoutranked-byとマッチしてしまうと
; 永遠にフィルタされることがなくなってしまうのでだめなんじゃないかなあ

