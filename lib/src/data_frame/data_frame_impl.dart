import 'package:ml_dataframe/src/data_frame/data_frame.dart';
import 'package:ml_dataframe/src/data_frame/data_frame_helpers.dart';
import 'package:ml_dataframe/src/data_frame/series.dart';
import 'package:ml_dataframe/src/numerical_converter/numerical_converter.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';

class DataFrameImpl implements DataFrame {
  DataFrameImpl(this.rows, this.header, this._toNumber) :
        series = convertRowsToSeries(header, rows);

  DataFrameImpl.fromSeries(this.series, this._toNumber) :
        header = series.map((series) => series.name),
        rows = convertSeriesToRows(series);

  @override
  final Iterable<String> header;

  @override
  final Iterable<Iterable<dynamic>> rows;

  @override
  final Iterable<Series> series;

  final Map<DType, Matrix> _cachedMatrices = {};

  final NumericalConverter _toNumber;

  @override
  Matrix toMatrix([DType dtype = DType.float32]) =>
    _cachedMatrices[dtype] ??= Matrix.fromList(
        _toNumber
            .convertRawData(rows)
            .map((row) => row.toList())
            .toList(),
    );

  @override
  Map<String, Series> get seriesByName =>
      _seriesByName ??= Map
          .fromEntries(series.map((series) => MapEntry(series.name, series)));
  Map<String, Series> _seriesByName;
}