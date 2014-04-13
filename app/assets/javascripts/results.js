(function() {
  var tooltip = d3.select(".chart")
    .append("div")
    .attr("class", "tooltip desktop")
    .on("mouseover", function() {
      tooltip.classed("visible", true);
    })
    .on("mouseout", function() {
      tooltip.classed("visible", false);
    });


  var answerType = tooltip.append("div").attr("class", "label-title");
  var votePercentage = tooltip.append("div").attr("class", "votePercentage");
  var voteCount = tooltip.append("div").attr("class", "label-title");

  function Graph(el, data) {
    var self = this;
    this.container = d3.select(el);
    this.data = data;
    this.barHeight = 40;
    this.barGap = 10;
    this.labelGap = this.barGap * 2;
    this.height = (this.barHeight + this.barGap) * data.answers.length + this.barGap;
    this.scale = {};
    this.bars = {};

    this.setChart();
    this.renderRows();

    d3.select(window).on("resize", this.rescale.bind(this));
  }

  Graph.prototype.rescale = function() {
    this.width = parseInt(this.container.style("width"), 10);
    this.chart.attr("width", this.width);

    this.setScale("desktop");
    this.setScale("mobile");

    this.animateBars("desktop");
    this.animateBars("mobile");
  };

  Graph.prototype.setChart = function() {
    this.chart = this.container
        .append("svg")
        .attr("height", this.height);
  };

  Graph.prototype.renderRows = function() {
    var self = this;

    this.rows = this.chart.selectAll("g")
      .data(this.data.answers)
    .enter().append("g")
      .attr("transform", function(d, i) {
        var y = i * (self.barHeight + self.barGap) + self.barGap;
        return "translate(0," + y +")";
      });

    this.renderBars("desktop");
    this.renderBars("mobile");

    this.renderLabels("desktop");
    this.renderLabels("mobile");

    this.rescale();

    this.renderLine("desktop");
    this.renderLine("mobile");

    this.renderBullshit();

    this.rows.on("mouseover", function(d, i) {
        tooltip
          .style("left", self.scale.desktop(d.votes) + self.barOffset + "px")
          .style("top", i * (self.barHeight + self.barGap) + self.barHeight/2 + "px")
          .classed("visible", true)
          .classed("correct", d.is_correct)
          .classed("wrong", !d.is_correct);
        answerType.text(d.is_correct ? "Correct Answer" : "Wrong Answer");
        votePercentage.text(Math.round((d.votes/self.data.votes_count) * 100) + "%");
        voteCount.text(d.votes + (d.votes==1 ? " person " : " people ") + "answered this");
      })
      .on("mouseout", function() { tooltip.classed("visible", false); });
  };

  Graph.prototype.renderBars = function(type) {
    var self = this;

    this.bars[type] = this.rows.append("rect")
      .attr("width", 0)
      .attr("height", this.barHeight)
      .classed(type, true)
      .classed("bar", true)
      .classed("vote", function(d) { return d.id === self.data.vote_answer_id; })
      .classed("correct", function(d) { return d.is_correct; });
  };

  Graph.prototype.renderLabels = function(type) {
    var labels = this.rows.append("text")
      .classed(type, true)
      .attr("x", this.barGap/2)
      .attr("y", 0)
      .attr("dy", "1.25em")
      .text(function(d) { return d.label; });

    if (type === "desktop") {
      this.barOffset = Math.max.apply(null, labels[0].map(function(label) {
        return Math.ceil(label.getBBox().width);
      })) + this.labelGap;

      labels.attr("x", this.barOffset - this.labelGap);
    }
  };

  Graph.prototype.setScale = function(type) {
    this.scale[type] = d3.scale.linear()
      .domain([0, d3.max(this.data.answers, function(answer) { return answer.votes; })])
      .range([0, type === "desktop" ? this.width - this.barOffset : this.width]);
  };

  Graph.prototype.animateBars = function(type) {
    var self = this;

    this.bars[type]
      .attr("x", type === "desktop" ? this.barOffset : 0)
      .transition()
        .delay(function(d, i) { return i * 50; })
        .duration(1000)
        .attr('width', function(d, i) { return Math.max(2, self.scale[type](d.votes)) });
  };

  Graph.prototype.renderLine = function(type) {
    this.chart.append("line")
      .classed(type, true)
      .attr("x1", type === "desktop" ? this.barOffset : 0)
      .attr("y1", 0)
      .attr("x2", type === "desktop" ? this.barOffset : 0)
      .attr("y2", this.height);
  };

  Graph.prototype.renderBullshit = function() {
    this.rows.append("rect")
      .attr("width", this.width)
      .attr("height", this.barHeight);
  };

  if (howwrong.options) {
    new Graph(".chart", howwrong.options);
  }

}());
