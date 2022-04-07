import "package:freezed_annotation/freezed_annotation.dart";

@optionalTypeArgs
class CallableFunction1<V1, R> {
  final R Function(V1) callback;

  const CallableFunction1(this.callback);

  R call(V1 v1) => callback(v1);
  R operator [](V1 v1) => callback(v1);
}

CallableFunction1<V1, R> callable1<V1, R>(R Function(V1) callback) => CallableFunction1(callback);
CallableFunction2<V1, V2, R> callable2<V1, V2, R>(R Function(V1, V2) callback) =>
    callable1((V1 v1) => callable1((V2 v2) => callback(v1, v2)));
CallableFunction3<V1, V2, V3, R> callable3<V1, V2, V3, R>(R Function(V1, V2, V3) callback) =>
    callable1((V1 v1) => callable2((V2 v2, V3 v3) => callback(v1, v2, v3)));
CallableFunction4<V1, V2, V3, V4, R> callable4<V1, V2, V3, V4, R>(R Function(V1, V2, V3, V4) callback) =>
    callable1((V1 v1) => callable3((V2 v2, V3 v3, V4 v4) => callback(v1, v2, v3, v4)));
CallableFunction5<V1, V2, V3, V4, V5, R> callable5<V1, V2, V3, V4, V5, R>(R Function(V1, V2, V3, V4, V5) callback) =>
    callable1((V1 v1) => callable4((V2 v2, V3 v3, V4 v4, V5 v5) => callback(v1, v2, v3, v4, v5)));

@optionalTypeArgs
typedef CallableFunction2<V1, V2, R> = CallableFunction1<V1, CallableFunction1<V2, R>>;

@optionalTypeArgs
typedef CallableFunction3<V1, V2, V3, R> = CallableFunction1<V1, CallableFunction2<V2, V3, R>>;

@optionalTypeArgs
typedef CallableFunction4<V1, V2, V3, V4, R> = CallableFunction1<V1, CallableFunction3<V2, V3, V4, R>>;

@optionalTypeArgs
typedef CallableFunction5<V1, V2, V3, V4, V5, R> = CallableFunction1<V1, CallableFunction4<V2, V3, V4, V5, R>>;

@optionalTypeArgs
typedef CallableFunction6<V1, V2, V3, V4, V5, V6, R> = CallableFunction1<V1, CallableFunction5<V2, V3, V4, V5, V6, R>>;
