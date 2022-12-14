# ============================================================================ #
#
# TestR Framework                                                             
# 
# Licensed Under The MIT License
# 
# Copyright (c) 2022 Berkant Yüksektepe
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# ============================================================================ #



#' Create Console Message with sprintf
#'
#' @param msg : String : Console Message
#' @param name : String : Test Name
#' 
#' @note msg parameter must be include sprintf string
#'
#' @return
#' @export Console Message
#'
#' @examples
Create.Console.Message.sprintf <- function(msg, name){
  msg %>% {
    sprintf(., name) %>% 
      yellow() %>% 
      cat()
  }
}

#' Create Console Message with only message
#'
#' @param msg : String : Console Message
#'
#' @return
#' @export Console Message
#'
#' @examples
Create.Console.Message <- function(msg){
  msg %>% {
    paste0(.) %>%
      yellow() %>% 
      cat()
  }
}

Create.Test.Index <- function(ra = 1:100,
                              qu = 5,
                              re = FALSE){
  
  Test.Index <- sample(ra,
                       qu,
                       re) %>% toString() %>% 
                                      str_replace_all(.,
                                                     ", ",
                                                     "-")
  Test.Index %>% return()
}

Control.Test.Execution <- function(ex){
  
}
