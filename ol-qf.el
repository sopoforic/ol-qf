;;; ol-qf.el --- support qf links in org-mode        -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Tracy Poff

;; Author: Tracy Poff <tracy.poff@gmail.com>
;; Keywords: local, org
;; Version: 0.0.1
;; Package-Requires: ((org "7") (org-roam))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Code:

(require 'org)
(require 'org-roam)

(defun ol-qf--url-for-key (key)
  "Return a qf url for the given KEY."
  (cl-multiple-value-bind (type id) (split-string key "-")
    (format "https://quoted.barbanon.org/%s/%s/" type id)))

(defun org-qf-open (key)
  "Open the qf url for KEY in the browser."
  (or (org-roam--find-ref key)
      (browse-url (ol-qf--url-for-key key))))

(defun org-qf-export (link description format)
  "Convert the qf type LINK to the given FORMAT, with link text DESCRIPTION."
  (let ((path (ol-qf--url-for-key link))
        (desc (or description link)))
    (pcase format
      (`html (format "<a target=\"_blank\" href=\"%s\">%s</a>" path desc))
      (`md (cl-multiple-value-bind (type key) (split-string link "-")
             (if description
                 (format "<%s id=\"%s\">%s</%s>" type key desc type)
               (format "<%s id=\"%s\" />" type key))))
      (_ path))))

(org-link-set-parameters "qf"
                         :follow #'org-qf-open
                         :export #'org-qf-export)

(provide 'ol-qf)
;;; ol-qf.el ends here
