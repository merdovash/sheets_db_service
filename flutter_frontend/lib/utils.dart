double convertRange(List<double> baseRange, List<double> targetRange, double value) {
  return (value - baseRange[0]) / ((baseRange[1] - baseRange[0]) / (targetRange[1] - targetRange[0])) + targetRange[0];
}