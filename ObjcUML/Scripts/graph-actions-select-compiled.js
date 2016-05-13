//  ===================================================
//  ===============  SELECTING_NODE       =============
//  ===================================================

'use strict';

var graph_actions = {
    create: function create(svg, dvgraph) {

        return {
            selectedIdx: -1,
            selectedType: "normal",
            svg: svg,
            selectedObject: {},
            dvgraph: dvgraph,

            deselect_node: function deselect_node(d) {
                delete d.fixed;
                this.selectedIdx = -1;
                this.selectedObject = {};

                this.svg.selectAll('circle').each(function (node) {
                    node.filtered = false;
                }).classed('filtered', false).transition();

                this.svg.selectAll('path, text').classed('filtered', false).transition();

                this.svg.selectAll('.link').attr("marker-end", "url(#default)").classed('filtered', false).classed('dependency', false).classed('dependants', false).transition();
            },

            deselect_selected_node: function deselect_selected_node() {
                this.deselect_node(this.selectedObject);
            },

            _lockNode: function _lockNode(node) {
                node.fixed = true;
            },

            _unlockNode: function _unlockNode(node) {
                delete node.fixed;
            },

            _selectAndLockNode: function _selectAndLockNode(node, type) {
                this._unlockNode(this.selectedObject);
                this.selectedIdx = node.idx;
                this.selectedObject = node;
                this.selectedType = type;
                this._lockNode(this.selectedObject);
            },

            _deselectNodeIfNeeded: function _deselectNodeIfNeeded(node, type) {
                if (node.idx == this.selectedIdx && this.selectedType == type) {
                    this.deselect_node(node);
                    return true;
                }
                return false;
            },

            _fadeOutAllNodesAndLinks: function _fadeOutAllNodesAndLinks() {
                // Fade out all circles
                this.svg.selectAll('circle').classed('filtered', true).each(function (node) {
                    node.filtered = true;
                    node.neighbours = false;
                }).transition();

                this.svg.selectAll('text').classed('filtered', true).transition();

                this.svg.selectAll('.link').classed('dependency', false).classed('dependants', false).transition().attr("marker-end", "");
            },

            _highlightNodesWithIndexes: function _highlightNodesWithIndexes(indexesArray) {
                this.svg.selectAll('circle, text').filter(function (node) {
                    return indexesArray.indexOf(node.index) > -1;
                }).classed('filtered', false).each(function (node) {
                    node.filtered = false;
                    node.neighbours = true;
                }).transition();
            },

            _isDependencyLink: function _isDependencyLink(node, link) {
                return link.source.index === node.index;
            },
            _nodeExistsInLink: function _nodeExistsInLink(node, link) {
                return link.source.index === node.index || link.target.index == node.index;
            },
            _oppositeNodeOfLink: function _oppositeNodeOfLink(node, link) {
                return link.source.index == node.index ? link.target : link.target.index == node.index ? link.source : null;
            },

            _highlightLinksFromRootWithNodesIndexes: function _highlightLinksFromRootWithNodesIndexes(root, nodeNeighbors, maxLevel) {
                var _this = this;

                this.svg.selectAll('.link').filter(function (link) {
                    return nodeNeighbors.indexOf(link.source.index) > -1;
                }).classed('filtered', false).classed('dependency', function (l) {
                    return _this._nodeExistsInLink(root, l) && _this._isDependencyLink(root, l);
                }).classed('dependants', function (l) {
                    return _this._nodeExistsInLink(root, l) && !_this._isDependencyLink(root, l);
                }).attr("marker-end", function (l) {
                    return _this._nodeExistsInLink(root, l) ? _this._isDependencyLink(root, l) ? "url(#dependency)" : "url(#dependants)" : maxLevel == 1 ? "" : "url(#default)";
                }).transition();
            },

            selectNodesStartingFromNode: function selectNodesStartingFromNode(node) {
                var maxLevel = arguments.length <= 1 || arguments[1] === undefined ? 100 : arguments[1];

                if (this._deselectNodeIfNeeded(node, "level" + maxLevel)) {
                    return;
                }
                this._selectAndLockNode(node, "level" + maxLevel);

                var neighborIndexes = this.dvgraph.nodesStartingFromNode(node, { max_level: maxLevel, use_backward_search: maxLevel == 1 }).map(function (n) {
                    return n.index;
                });

                this._fadeOutAllNodesAndLinks();
                this._highlightNodesWithIndexes(neighborIndexes);
                this._highlightLinksFromRootWithNodesIndexes(node, neighborIndexes, maxLevel);
            }

        };
    }
};

//# sourceMappingURL=graph-actions-select-compiled.js.map