/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef LIB_TXT_SRC_LINE_METRICS_H_
#define LIB_TXT_SRC_LINE_METRICS_H_

#include <map>
#include <vector>

#include "run_metrics.h"

namespace txt {

class LineMetrics {
 public:
  // The following variables are used in the layout process itself.

  // The indexes in the text buffer the line begins and ends.
  size_t start, end;
  size_t end_excluding_whitespace;
  size_t end_including_newline;
  bool hard_break;

  // The following variables are tracked after or during layout to provide to
  // the user.

  // The final computed ascent and descent for the line. This can be impacted by
  // the strut, height, scaling, as well as outlying runs that are very tall.
  //
  // The top edge is `baseline - ascent` and the bottom edge is `baseline +
  // descent`. Ascent and descent are provided as positive numbers.
  double ascent;
  double descent;
  // Width of the line.
  double width;
  // The left edge of the line. The right edge can be obtained with `left +
  // width`
  double left;
  // The y position of the baseline for this line from the top of the paragraph.
  double baseline;
  // Zero indexed line number.
  size_t line_number;

  // Mapping between text index ranges and the FontMetrics associated with
  // them. The first run will be keyed under start_index. The metrics here
  // are before layout and are the base values we calculate from.
  std::map<size_t, RunMetrics> run_metrics_map;

  LineMetrics();

  LineMetrics(size_t s, size_t e, size_t eew, size_t ein, bool h)
      : start(s),
        end(e),
        end_excluding_whitespace(eew),
        end_including_newline(ein),
        hard_break(h) {}

  // GetFontMetricsAtIndex(size_t index);
};

}  // namespace txt

#endif  // LIB_TXT_SRC_LINE_METRICS_H_
