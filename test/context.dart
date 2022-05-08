import "package:parser/context.dart";
import "package:parser/src/util/shared/unindent.dart";
import "package:test/test.dart";

void main() {
  Context base = Context.empty(State(buffer: "", parseMode: ParseMode.packrat));

  group("method calls", () {
    test("index", () {
      Context advanced = base.index(5);

      expect(advanced.state.index, 5);
    });

    test("advance", () {
      Context advanced = base.advance(12);
      expect(advanced.state.index, 12);
      advanced = advanced.advance(3);
      expect(advanced.state.index, 15);
      advanced = advanced.advance(-3);
      expect(advanced.state.index, 12);
    });

    test("indent", () {
      Context inner = base.copyWith();
      expect(base.state.indentStack, <int>[]);
      inner = inner.indent(<int>[2]);
      expect(inner.state.indentStack, <int>[2]);
      inner = inner.indent(<int>[]);
      expect(inner.state.indentStack, <int>[]);
    });

    test("push & pop", () {
      Context inner = base.copyWith();
      expect(inner.state.dataStack, <dynamic>[]);
      inner = inner.push("hello");
      expect(inner.state.dataStack, <dynamic>["hello"]);
      inner = inner.push("goodbye");
      expect(inner.state.dataStack, <dynamic>["hello", "goodbye"]);
      inner = inner.pop();
      expect(inner.state.dataStack, <dynamic>["hello"]);
      inner = inner.pop();
      expect(inner.state.dataStack, <dynamic>[]);
    });
  });
  group("conversion", () {
    test("empty", () {
      Context converted = base.copyWith();
      expect(converted, isA<ContextEmpty>());
      converted = converted.success("").empty();
      expect(converted, isA<ContextEmpty>());
    });
    test("success", () {
      Context converted = base.copyWith();
      expect(converted, isA<ContextEmpty>());
      converted = converted.success("yes", "no");
      expect(converted, isA<ContextSuccess>());
      converted as ContextSuccess;
      expect(converted.mappedResult, "yes");
      expect(converted.unmappedResult, "no");
    });
    test("failure", () {
      Context converted = base.copyWith();
      expect(converted, isA<ContextEmpty>());
      converted = converted.failure("in-test");
      expect(converted, isA<ContextFailure>());
      converted as ContextFailure;
      expect(converted.message, "in-test");
      converted = converted.withFailureMessage();

      late String message = """
          Failure: in-test
           --> 1:1
            |
          1 |  ·
            |  ^
            |
          """
          .unindent();
      expect(converted.message.trimRight(), message);
    });
  });
  group("predicates", () {
    test("empty", () {
      Context converted = base.success("").empty();
      expect(converted, isA<ContextEmpty>());
      expect(converted.isFailure, isFalse);
      expect(converted.isSpecificSuccess, isFalse);
      expect(converted.isSuccess, isTrue);
    });
    test("success", () {
      Context converted = base.success("yes", "no");
      expect(converted, isA<ContextSuccess>());
      converted as ContextSuccess;
      expect(converted.isFailure, isFalse);
      expect(converted.isSpecificSuccess, isTrue);
      expect(converted.isSuccess, isTrue);
    });
    test("failure", () {
      Context converted = base.failure("in-test");
      expect(converted, isA<ContextFailure>());
      converted as ContextFailure;
      expect(converted.isFailure, isTrue);
      expect(converted.isSpecificSuccess, isFalse);
      expect(converted.isSuccess, isFalse);
    });
  });
}
