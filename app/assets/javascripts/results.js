function drawAnswersGraph() {
  var body = d3.select("body");

  var count = 0, 
    data = [];
  var numberOfOptions = howwrong.options.answers.length;
  while (count < numberOfOptions) {
    data[count] = howwrong.options.answers[count].votes;
    count++;
  }
  
  var width = 420,
    barHeight = 50;

  var x = d3.scale.linear()
      .domain([0, d3.max(data)])
      .range([0, width]);

  var chart = d3.select(".chart")
      .attr("width", width)
      .attr("height", barHeight * data.length);

  var bar = chart.selectAll("g")
      .data(data)
    .enter().append("g")
      .attr("transform", function(d, i) { return "translate(0," + i * barHeight + ")"; });

  bar.append("rect")
      .transition()
        .attr("width", x)
        .attr("height", barHeight - 10)
        .attr("class", "bar");

  bar.append("text")
      .attr("x", function(d) { return x(d) - 3; })
      .attr("y", barHeight / 2 - 5)
      .attr("dy", ".35em")
      .text(function(d) { return d; });
}