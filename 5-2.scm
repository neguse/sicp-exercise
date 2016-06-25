(data-paths
  (registers
	((name p)
	 (buttons
	   ((name p<-1) (source (constant 1)))
	   ((name p<-m) (source (operation m)))))
	((name c)
	 (buttons
	   ((name c<-1) (source (constant 1)))
	   ((name c<-a) (source (operation a)))))
	((name n)))

  (operations
	((name m)
	 (inputs (register p) (register c)))
	((name p)
	 (inputs (register c) (constant 1))) 
	((name >)
	 (inputs (register n) (register c))))
  )

(controller
  ; nはだれが初期化するのか…なぞです
  (p<-1)
  (c<-1)
fact-iter
  (test >)
  (branch (label fact-done))
  (p<-m)
  (c<-a)
  (goto (label fact-iter))
fact-done
)

