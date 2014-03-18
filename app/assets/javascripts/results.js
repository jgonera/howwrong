$(function() {
  var body = d3.select("body"),
      data = howwrong.options.answers,
      vote_answer_id = howwrong.options.vote_answer_id;
  
  var width = 520,
      barHeight = 50;

  var x = d3.scale.linear()
      .domain([0, d3.max(data, function(answer) { return answer.votes; })])
      .range([0, width-100]);

  var chart = d3.select(".chart")
      .attr("width", width)
      .attr("height", barHeight * data.length);

  var bar = chart.selectAll("g")
      .data(data)
    .enter().append("g")
      .attr("transform", function(d, i) { return "translate(0," + i * barHeight + ")"; });

  bar.append("rect")
      .attr ("x", 130)
      .attr("width", 0)
      .attr("height", barHeight - 10)
      .classed("bar", true)
      .classed("vote", function(d) { return d.id === vote_answer_id; })
      .classed("correct", function(d) { return d.is_correct; })
      .transition()
        .delay(function(d, i) { return i * 50; })
        .duration(1000)
        .attr('width', function(d, i) { return x(d.votes) });

  bar.append("text")
      .attr("class", "label")
      .attr("x", 100)
      .attr("y", barHeight / 2 - 5)
      .attr("dy", ".35em")
      .text(function(d) { return d.label; });

  bar.append("text")
      .attr("x", function(d) { return x(d.votes) + 130; })
      .attr("y", barHeight / 2 - 5)
      .attr("dy", ".35em")
      .text(function(d) { return d.votes; });

});