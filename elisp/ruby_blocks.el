(find-file "testing.rb")
(goto-char 1)
(re-search-forward "\(module\|class\|def\|begin\)")
(while moreLines
  (setq moreLines (= 0 (forward-line 0)))
  (print moreLines)
  )
