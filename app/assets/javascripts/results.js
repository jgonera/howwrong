$(function() {
  var body = d3.select("body"),
      votes = howwrong.options.answers.map(function(answer) { return answer.votes; });
      label = howwrong.options.answers.map(function(answer) { return answer.label; });
      data = howwrong.options.answers.map(function(answer) { return [answer.label, answer.votes]});
  
  var width = 520,
      barHeight = 50;

  var x = d3.scale.linear()
      .domain([0, d3.max(votes)])
      .range([0, width-100]);

  var chart = d3.select(".chart")
      .attr("width", width)
      .attr("height", barHeight * votes.length);

  var bar = chart.selectAll("g")
      .data(data)
    .enter().append("g")
      .attr("transform", function(d, i) { return "translate(0," + i * barHeight + ")"; });

  bar.append("rect")
      .attr ("x", 130)
      .attr("width", 0)
      .attr("height", barHeight - 10)
      .attr("class", "bar")
      .transition()
        .delay(function(d, i) { return i * 50; })
        .duration(1000)
        .attr('width', function(d, i) { return x(d[1]) });

  bar.append("text")
      .attr("class", "label")
      .attr("x", 100)
      .attr("y", barHeight / 2 - 5)
      .attr("dy", ".35em")
      .text(function(d) { return d[0]; });

  bar.append("text")
      .attr("x", function(d) { return x(d[1]) + 130; })
      .attr("y", barHeight / 2 - 5)
      .attr("dy", ".35em")
      .text(function(d) { return d[1]; });

});