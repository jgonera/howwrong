//= require d3.js

$(function() {
  var tooltip = d3.select(".chart")
    .append("div")
    .attr("class", "tooltip")
    .on("mouseover", function() {
      tooltip.classed("visible", true);
    })
    .on("mouseout", function() {
      tooltip.classed("visible", false);
    });

  var answerType = tooltip.append("div").attr("class", "label-title");
  var votePercentage = tooltip.append("div").attr("class", "votePercentage");
  var voteCount = tooltip.append("div").attr("class", "label-title");

  var data = howwrong.options.answers,
      vote_answer_id = howwrong.options.vote_answer_id,
      votes_count = howwrong.options.votes_count;

  var width = 600,
      barHeight = 40,
      barGap = 10,
      labelGap = barGap * 2,
      height = (barHeight + barGap) * data.length + barGap,
      labelWidth,
      x;

  var chart = d3.select(".chart")
      .append("svg")
      .attr("width", width)
      .attr("height", height);

  var bar = chart.selectAll("g")
      .data(data)
    .enter().append("g")
      .attr("transform", function(d, i) {
        var y = i * (barHeight + barGap) + barGap;
        return "translate(0," + y +")";
      })
      .on("mouseover", function(d, i) {
        tooltip
          .style("left", x(d.votes) + labelWidth + "px")
          .style("top", i * (barHeight + barGap) + barHeight/2 + "px")
          .classed("visible", true)
          .classed("correct", d.is_correct)
          .classed("wrong", !d.is_correct);
        answerType.text(d.is_correct ? "Correct Answer" : "Wrong Answer");
        votePercentage.text(Math.round((d.votes/votes_count) * 100) + "%");
        voteCount.text(d.votes + (d.votes==1 ? " person " : " people ") + "answered this");
      })
      .on("mouseout", function() { tooltip.classed("visible", false); });

  var labels = bar.append("text")
      .attr("class", "label")
      .attr("y", 0)
      .attr("dy", "1.25em")
      .text(function(d) { return d.label; });

  labelWidth = Math.max.apply(null, labels[0].map(function(label) {
    return Math.ceil(label.getBBox().width);
  })) + labelGap;

  labels.attr("x", labelWidth - labelGap);

  x = d3.scale.linear()
      .domain([0, d3.max(data, function(answer) { return answer.votes; })])
      .range([0, width - labelWidth]);

  bar.append("rect")
      .attr("x", labelWidth)
      .attr("width", 0)
      .attr("height", barHeight)
      .classed("bar", true)
      .classed("vote", function(d) { return d.id === vote_answer_id; })
      .classed("correct", function(d) { return d.is_correct; })
      .transition()
        .delay(function(d, i) { return i * 50; })
        .duration(1000)
        .attr('width', function(d, i) { return Math.max(2, x(d.votes)) });

  bar.append("rect")
      .attr("width", width)
      .attr("height", barHeight);

  chart.append("line")
      .attr("x1", labelWidth)
      .attr("y1", 0)
      .attr("x2", labelWidth)
      .attr("y2", height);

});

