package;

import utest.ui.common.HeaderDisplayMode;
import utest.ui.Report;
import utest.Runner;
import cases.*;

class TestAll {
    public static function main() {
        var runner = new Runner();
        
        runner.addCase(new TestQuery());
        runner.addCase(new TestPreparedQuery());
        runner.addCase(new TestInnerJoin());
        runner.addCase(new TestPreparedInnerJoin());
        runner.addCase(new TestInsert());
        #if !neko // neko returns blobs as strings (rather than bytes), im not sure its worth the effort to work around it, things will still work, the rs just holds strings instead of bytes
        runner.addCase(new TestBlob());
        #end

        Report.create(runner, SuccessResultsDisplayMode.AlwaysShowSuccessResults, HeaderDisplayMode.NeverShowHeader);
        runner.run();
    }
}