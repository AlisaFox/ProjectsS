(defun minimum (lst) 
  "(lst)
finds the minimum number in a list"
  (do ((list (cdr lst) (cdr list))                              ;this is the list to cycle through 
       (min (car lst) ))                                        ;min holder, start off w/ first number
      ((null list) min)                                         ;exit once list is empty
    (if (< (car list) min) (setf min (car list)))               ;comparison of first item in list w/ min
    )
  )


(defun add-to-list (x lst)
  "(x lst)
adds x to each number in the lst"
  (mapcar (lambda (lst) (+ x lst)) lst)                          ;cycles through the lst, x stays the same
  )


(defun first-odd (lst)
  "(lst)
finds the first odd integer in the list, returns 'none if none found"
  (do ((l lst (cdr l))
       (result 0 (if (oddp (car l)) (return (car l)))))            ;will either exit the function here if odd is found
      ((null l) 'none))                                            ;or will exit here with 'none if no odd found
  )


(defun activation (type sum)
  (cond ((eq type 'sigmoid) (- (/ 1 (+ 1 (exp (- 0 sum)))) 0.5))
        ((eq type 'asigmoid) (/ 1 (+ 1 (exp (- 0 sum)))))
        (t 'unknown-type)
        )
  )


(defun satisfy (fun lst)
  "(fun lst)
returns a list of all items in lst that satisfy fun, returns nill if none do
note: the else statement had to be written, otherwise newlst would reset back to nil for some reason"
  (do ((oldlst lst (cdr oldlst))                                                                        ;go through lst one by one
       (newlst '() (if (funcall fun (car oldlst)) (cons (car oldlst) newlst) (append () newlst ))))     ;if matches fun, add to new lst, 
      ((null oldlst) (reverse newlst))                                                                  ;reverse the result to make it match 
    )                                                                                                 
  )
