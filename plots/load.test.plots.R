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

library(ggpubr)
library(ggplot2)
library(grid)
library(gridExtra)

tc_plot_response_code <- function(results)
{
  
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package ggplot2 is needed for this function.", 
         call. = FALSE)
  }
  
ggplot2::ggplot(results, ggplot2::aes(x = time_since_start,
                 y = response_code,
                 colour = response_message)) +
  ggplot2::geom_boxplot(notch = TRUE) +
  ggplot2::facet_grid( request_status ~ response_message )+
  ggplot2::labs(x = 'Time since start (milliseconds)',
                y = 'Response Code')+
  
  ggplot2::labs(colour = 'Response Message') +
  ggplot2::theme_bw() +
  ggplot2::theme(
    legend.position = 'bottom'
  )
}

tc_plot_elapsed_times <- function (results) 
{
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package ggplot2 is needed for this function.", 
         call. = FALSE)
  }
  ggplot2::ggplot(results, ggplot2::aes(x = time_since_start, 
                                        y = elapsed, color = request_status)) + ggplot2::geom_point() +
    ggplot2::labs(x = "Time since start (milliseconds)", 
                  y = "Time to complete request (milliseconds)", color = "Request status", 
                  title = "Time to complete request over duration of test", 
                  caption = "Horizontal line is the median response") + 
    ggplot2::theme_minimal() + ggplot2::scale_color_manual(values = c("#ff0000", 
                                                                      "#1d67b9"), drop = FALSE) + ggplot2::theme(legend.position = "bottom") + 
    ggplot2::scale_y_continuous(limits = c(0, NA)) + ggplot2::geom_hline(yintercept = median(results$elapsed))
}


tc_plot_elapsed_times_histogram <- function (results, binwidth = 250) 
{
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package ggplot2 is needed for this function.", 
         call. = FALSE)
  }
  ggplot2::ggplot(results, ggplot2::aes(x = elapsed, fill = request_status)) + 
    ggplot2::geom_histogram(binwidth = binwidth, color = "#000000") + 
    ggplot2::scale_x_continuous(breaks = seq(0, max(results[["elapsed"]]) * 
                                               2, binwidth)) + ggplot2::theme_minimal() + ggplot2::scale_fill_manual(values = c("#ff0000", 
                                                                                                                                "#1d67b9"), drop = FALSE) + ggplot2::labs(x = "Time to complete response (milliseconds)", 
                                                                                                                                                                          fill = "Request status", title = "Distribution of time to complete responses") + 
    ggplot2::theme(legend.position = "bottom")
}


tc_plot_requests_by_thread <- function (results) 
{
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package ggplot2 is needed for this function.", 
         call. = FALSE)
  }
  results[["thread"]] <- factor(results[["thread"]], levels = 1:max(results[["thread"]]))
  ggplot2::ggplot(results, ggplot2::aes(x = time_since_start, 
                                        y = thread, color = request_status)) + ggplot2::geom_point() + 
    ggplot2::theme_minimal() + ggplot2::scale_color_manual(values = c("#ff0000", 
                                                                      "#1d67b9"), drop = FALSE) + ggplot2::labs(x = "Time since start (milliseconds)", 
                                                                                                                y = "Thread", color = "Request status", title = "Timeline of requests by thread", 
                                                                                                                caption = "Point is at time of the start of request") + 
    ggplot2::theme(legend.position = "bottom")
}


tc_plot_requests_per_second <- function (results) 
{
  if (!any(c(requireNamespace("ggplot2", quietly = TRUE), 
             requireNamespace("dplyr", quietly = TRUE), requireNamespace("tidyr", 
                                                                         quietly = TRUE)))) {
    stop("Packages ggplot2, dplyr, and tidyr are needed for this function.", 
         call. = FALSE)
  }
  results[["time_since_start_rounded"]] <- floor(results[["time_since_start"]]/1000)
  counts <- dplyr::count(results, time_since_start_rounded)
  counts <- tidyr::complete(counts, time_since_start_rounded = seq(min(time_since_start_rounded), 
                                                                   max(time_since_start_rounded), 1), fill = list(n = 0))
  counts <- dplyr::count(counts, n)
  counts[["p"]] <- counts[["nn"]]/sum(counts[["nn"]])
  counts <- tidyr::complete(counts, n = 0:max(n), fill = list(nn = 0, 
                                                              p = 0))
  counts[["label"]] <- paste0(round(counts[["p"]], 2) * 100, 
                              "%")
  counts[["label"]] <- ifelse(counts[["nn"]] == 0, "", counts[["label"]])
  ggplot2::ggplot(counts, ggplot2::aes(x = n, y = p, label = label)) + 
    ggplot2::geom_col(fill = "#1d67b9", color = "#000000") + 
    ggplot2::theme_minimal() + ggplot2::geom_text(vjust = -0.5) + 
    ggplot2::scale_x_continuous(breaks = seq(0, 1000, 1)) + 
    ggplot2::scale_y_continuous(limits = c(0, 1), labels = function(x) paste0(round(x, 
                                                                                    2) * 100, "%")) + ggplot2::labs(x = "Requests per second", 
                                                                                                                    y = "Percent of time at that rate", title = "Distribution of number of responses within a second")
}