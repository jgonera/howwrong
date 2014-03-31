//= require d3.js

$(function() {
  var tooltip = d3.select("body")
    .append("div")
    .attr("class", "tooltip");

  var answerType = tooltip.append("div").attr("class", "label-title");
  var votePercentage = tooltip.append("div").attr("class", "votePercentage");
  var voteCount = tooltip.append("div").attr("class", "label-title bottom");

  var body = d3.select("body"),
      data = howwrong.options.answers,
      vote_answer_id = howwrong.options.vote_answer_id,
      votes_count = howwrong.options.votes_count;

  var width = 700,
      barHeight = 50;

  var x = d3.scale.linear()
      .domain([0, d3.max(data, function(answer) { return answer.votes; })])
      .range([0, width-300]);

  var chart = d3.select(".chart")
      .attr("width", width)
      .attr("height", barHeight * data.length + 10);

  var bar = chart.selectAll("g")
      .data(data)
    .enter().append("g")
      .attr("transform", function(d, i) {
        var y = i * barHeight + 10;
        return "translate(0," + y +")";
      })
      .on("mouseover", function(d, i) {
        tooltip
          .style("left", x(d.votes)+window.innerWidth/2+"px")
          .style("top", (i * barHeight) + 10 + 525 +"px")
          .classed("visible", true)
          .classed("correct", d.is_correct)
          .classed("wrong", !d.is_correct);
        answerType.text(d.is_correct ? "Correct Answer" : "Wrong Answer");
        votePercentage.text(Math.round((d.votes/votes_count) * 100) + "%");
        voteCount.text(d.votes + (d.votes==1 ? " person " : " people ") + "answered this");
      })
      .on("mouseout", function() { return tooltip.classed("visible", false); });

  bar.append("rect")
      .attr("x", 245)
      .attr("width", 0)
      .attr("height", barHeight - 10)
      .classed("bar", true)
      .classed("vote", function(d) { return d.id === vote_answer_id; })
      .classed("correct", function(d) { return d.is_correct; })
      .transition()
        .delay(function(d, i) { return i * 50; })
        .duration(1000)
        .attr('width', function(d, i) { return Math.max(2, x(d.votes)) });

  bar.append("rect")
      .attr("width", function(d) { return Math.max(2, x(d.votes)) + 245; })
      .attr("height", barHeight);

  bar.append("text")
      .attr("class", "label")
      .attr("x", 230)
      .attr("y", barHeight / 2 - 5)
      .attr("dy", ".35em")
      .text(function(d) { return d.label; });

  var line = chart.append("line")
      .attr("x1", 245)
      .attr("y1", 0)
      .attr("x2", 245)
      .attr("y2", 800)
      .attr("style", "stroke:#6b656e; stroke-width:1");

});
