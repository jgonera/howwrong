$(function() {
  var tooltip = d3.select("body")
    .append("div")
    .append("span")
    .attr("class", "tooltip")
    .style("position", "absolute")
    .style("z-index", "10")
    .style("visibility", "hidden")
    .style("background-color", "#000")
    .text("a simple tooltip");

  var body = d3.select("body"),
      data = howwrong.options.answers,
      vote_answer_id = howwrong.options.vote_answer_id;

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
        var y = (i * barHeight) + 10;
       return "translate(0," + (y) +")"; });

  bar.append("rect")
      .attr ("x", 260)
      .attr("width", 0)
      .attr("height", barHeight - 10)
      .classed("bar", true)
      .classed("vote", function(d) { return d.id === vote_answer_id; })
      .classed("correct", function(d) { return d.is_correct; })
      .on("mouseover", function(d, i) {
          tooltip.style("left", (d3.mouse(this)[0]+"px"));
          tooltip.style("top", (d3.mouse(this)[1]+"px"));
          tooltip.style("visibility", "visible");
          tooltip.text(d.votes);
        })
      .on("mousemove", function(d, i) {
        tooltip.style("left", ((x(d.votes))+700)+"px");
        tooltip.style("top", (i * barHeight) + 10 + 350 +"px");
        console.log(d);
       })
      .on("mouseout", function() { return tooltip.style("visibility", "hidden"); })
      .transition()
        .delay(function(d, i) { return i * 50; })
        .duration(1000)
        .attr('width', function(d, i) { return x(d.votes) });

  bar.append("text")
      .attr("class", "label")
      .attr("x", 230)
      .attr("y", barHeight / 2 - 5)
      .attr("dy", ".35em")
      .text(function(d) { return d.label; });

  var line = chart.append("line")
      .attr("x1", 260)
      .attr("y1", 0)
      .attr("x2", 260)
      .attr("y2", 800)
      .attr("style", "stroke:#6b656e; stroke-width:1");

});