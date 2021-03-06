(require 'ert)
(require 'bm (expand-file-name "./bm.el"))

;; to run tests from command line
;; > emacs -batch -l ert -l bm-tests.el -f ert-run-tests-batch-and-exit



(defvar text "This is a multi line text.
This is the second line.
This is the thrid line.
The next line is blank.

The previous line is blank.
This is the last line.")

(ert-deftest bm-bookmark-add-test ()
  (with-temp-buffer
    (insert text)
    (goto-line 2)
    (bm-bookmark-add)

    (should (= (bm-count) 1))

    (goto-char (point-min))
    (bm-next)
    (let ((bookmark (bm-bookmark-at (point))))
      (should (= (overlay-start bookmark) 28 )))
    ))


(ert-deftest bm-bookmark--add-remove-test ()
  (with-temp-buffer
    (insert text)
    (goto-line 2)
    (bm-bookmark-add)

    (should (= (bm-count) 1))

    (goto-char (point-min))
    (bm-next)
    (bm-bookmark-remove)

    (should (= (bm-count) 0))
    ))



(ert-deftest bm-bookmark--multiple-bookmarks-forward-wrapping ()
  (with-temp-buffer
    (insert text)
    (goto-line 2)
    (bm-bookmark-add)
    (goto-line 5)
    (bm-bookmark-add)

    (should (= (bm-count) 2))

    (goto-char (point-min))
    (bm-next)
    (let ((bookmark (bm-bookmark-at (point))))
      (bm-next)
      (bm-next)
      (should (bm-equal (bm-bookmark-at (point)) bookmark)))
    ))

(ert-deftest bm-bookmark--bm-temporary-bookmark ()
  (with-temp-buffer
    (insert text)
    (goto-line 2)
    (bm-bookmark-add nil nil t)
    (goto-line 5)
    (bm-bookmark-add nil nil t)

    (should (= (bm-count) 2))

    (goto-char (point-min))
    (bm-next)
    (should (= (bm-count) 1))

    (goto-char (point-min))
    (bm-previous)
    (should (= (bm-count) 0))
    ))
(ert-deftest bm-bookmark--option-bm-temporary-bookmark ()
  (let ((temporary-bookmark-p t))
    (with-temp-buffer
      (insert text)
      (goto-line 2)
      (bm-bookmark-add)
      (goto-line 5)
      (bm-bookmark-add)

      (should (= (bm-count) 2))

      (goto-char (point-min))
      (bm-next)
      (should (= (bm-count) 1))

      (goto-char (point-min))
      (bm-previous)
      (should (= (bm-count) 0)))
    ))
(ert-deftest bm-bookmarkp-test ()
  (with-temp-buffer
    (insert text)
    (goto-line 2)
    (bm-bookmark-add)
    (let ((bm (bm-bookmark-at (point))))
      (should (bm-bookmarkp bm))

      (bm-bookmark-remove bm)
      ;; after removed. bm-bookmarkp should return nil
      (should (not (bm-bookmarkp bm)))
      (should (not (bm-bookmarkp nil)))
      (should (not (bm-bookmarkp (bm-bookmark-at (point)))))
      )))


