'use strict';

const {parse} = require('toml');
const {readFileSync} = require("fs");

// Read all data from STDIN
const data = readFileSync(0, "utf-8");
const conf = parse(data);

const flattenPlugins = (prefix, w) => {
	const map = {};
	for(const p in w) {
		for(const n in w[p]) {
			map[`${prefix}\u0000${p}\u0000${n}\u0000`] = w[p][n];
		}
	}
	return map;
};

const asWeights = c => [
	{
		type: "sourcecred/weights",
		version: "0.1.0"
	},
	{
		nodeTypeWeights: {...flattenPlugins("N\u0000sourcecred", c.node)},
		edgeTypeWeights: {},
		nodeManualWeights: {},
	}
];

console.log(JSON.stringify(
	asWeights(conf)
));
