var w = 900px,
    h = 600px;
    
var svg = d3.select("body")
            .append("svg")
            .attr("width", w)
            .attr("height", h);

var force = d3.layout.force()
            .size([w], [h])
            .linkStrength(0.1)
            .linkDistance(30)
            .friction(0.9)
            .charge(-50)
            .chargeDistance(100)
            .gravity(0.25)
            .theta(0.8)
            .alpha(1.0)
            .start();
/*var circle = d3.selectAll("circle")
               .data(dataset)
               .enter()
               .append("circle");

circle.attr("fill", "blue")
      .attr("r", function() {return sqrt(foo.userCount) * 0.15});       //Need to set the cx and cy for spatial "awareness"
*/

d3.json("words.json", function(error, graph) {
    if(error) throw error;

    force.nodes(graph.nodes)
         .links(graph.links);

    var link = svg.selectAll(".link")
                .data(graph.links)
                .enter().append("line")
                .attr("class", "link")
                .style("stroke-width", function(d) { return Math.sqrt(d.value); });

    var node = svg.selectAll(".node")
                .data(graph.nodes)
                .enter().append("circle")
                .attr("class", "node")
                .attr("r", 5)
                .style("fill", function(d) { return color(d.group); })
                .call(force.drag);

    node.append("title")
        .text(function(d) { return d.name; });

    force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });
});
    