
; > (from-accountの残高は, 少なくてもamountであると仮定せよ.) 
; ってあるし、大丈夫だと思うんですけど…

; どこが違うかというと、結果整合性が担保されるところじゃないですかね。

; http://labs.timedia.co.jp/2015/02/sicp-sec-3.4-ex-3.42.html
; > 口座という共有リソースに対して複数回に渡る操作を行うなら全体をserializeする必要がありますが、 
; > 既にserializeされている deposit や withdraw を一回使うだけで良いなら全体をserializeする必要はありません。
; なるほど。複数か一回かという点が鍵っぽいです。

