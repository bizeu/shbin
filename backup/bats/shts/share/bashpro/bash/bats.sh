#!/usr/bin/env bash
# shellcheck disable=SC2034

#
# Bats Core Variables

# <html><h2>Add timing information to tests </h2>
# <p><strong><code>$BATS_ENABLE_TIMING</code></strong>.</p>
# <p><strong><code>bats --timing</code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_ENABLE_TIMING

# <html><h2>Test File Extension</h2>
# <p><strong><code>$BATS_FILE_EXTENSION</code></strong> specifies the extension of test files that
# should be found when running a test suite.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print extension</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Extension: $BATS_FILE_EXTENSION&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_FILE_EXTENSION

# <html><h2>Directory For Temporary Test Files</h2>
# <p><strong><code>$BATS_FILE_TMPDIR</code></strong> is the path to the temporary directory
# common to all tests of a test file.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print directory path</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Path: $BATS_FILE_TMPDIR&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_FILE_TMPDIR

# Library directory:
# Applications/PyCharm.app/Contents/bin/plugins/bashsupport-pro/bats-core/libexec/bats-core
export BATS_LIBEXEC

# <html><h2>Serialize test file execution instead of running them in parallel </h2>
# <p><strong><code>$BATS_NO_PARALLELIZE_ACROSS_FILES</code></strong> (requires --jobs >1).</p>
# <p><strong><code>bats --no-parallelize-across-files</code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_NO_PARALLELIZE_ACROSS_FILES

# <html><h2>Disable Parallelize within a single file </h2>
# <p><strong><code>$BATS_NO_PARALLELIZE_WITHIN_FILE</code></strong> true (bool) in 'setup_file()' disables for file.</p>
# <p><strong><code>bats --no-parallelize-within-files</code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_NO_PARALLELIZE_WITHIN_FILE

# <html><h2>Number of parallel jobs (requires GNU parallel) </h2>
# <p><strong><code>$BATS_NUMBER_OF_PARALLEL_JOBS</code></strong></p>
# <p><strong><code>bats --jobs <jobs></code></strong></p>
# <a href="https://bats-core.readthedocs.io/en/stable/usage.html#parallel-execution">parallel-execution</a>
# </html>
export BATS_NUMBER_OF_PARALLEL_JOBS

# Output file:
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-6576/bats.6612.out
export BATS_OUT

# Name (not a file/file):
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7204/bats.7229
export BATS_PARENT_TMPNAME

# The repository of bats-core :
# /Applications/PyCharm.app/Contents/bin/plugins/bashsupport-pro/bats-core
export BATS_ROOT

# <html><h2>Last Used <code>run</code> Command</h2>
# <p><strong><code>$BATS_RUN_COMMAND</code></strong> is the last executed <code>run</code>
# command used in your test case.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print last run command</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# run test
# echo &quot;Last run command: $BATS_RUN_COMMAND&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_RUN_COMMAND

# <html><h2>Path to Directory For Temporary bats Files</h2>
# <p><strong><code>$BATS_RUN_TMPDIR</code></strong> is the path to a directory,
# where bats stores its own temporary files.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print directory</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;$BATS_RUN_TMPDIR&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_RUN_TMPDIR

# <html><h2>Index of Current Test in Suite</h2>
# <p><strong><code>$BATS_SUITE_TEST_NUMBER</code></strong> is the index of the current test
# case in the test suite.<br />
# The test suite covers all test cases of all test files.</p>
# <p><code>$BATS_TEST_NUMBER</code> is similar, but for the current file.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print current test index in suite</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Index: $BATS_SUITE_TEST_NUMBER&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare -i BATS_SUITE_TEST_NUMBER

# <html><h2>Directory for Temporary Suite Files</h2>
# <p><strong><code>$BATS_SUITE_TMPDIR</code></strong> is the path to the temporary directory common
# to all test of a suite.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print directory path</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Path: $BATS_SUITE_TMPDIR&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_SUITE_TMPDIR

# <html><h2>Description of Current Test Case</h2>
# <p><strong><code>$BATS_TEST_DESCRIPTION</code></strong> is the description of the current test case.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print test description</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example test with output to STDOUT&quot; {
# echo &quot;Description: $BATS_TEST_DESCRIPTION&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_TEST_DESCRIPTION

# <html><h2>Parent Directory of The Test File</h2>
# <p><strong><code>$BATS_TEST_DIRNAME</code></strong> is the path to the directory containing the
# current bats test file</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print parent directory path</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Parent: $BATS_TEST_DIRNAME&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_TEST_DIRNAME

# <html><h2>Path to The Test File</h2>
# <p><strong><code>$BATS_TEST_FILENAME</code></strong> is the fully expanded path to the current bats test file.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print the path to the current test file</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Path: $BATS_TEST_FILENAME&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_TEST_FILENAME

# <html><h2>Function Name of Test</h2>
# <p><strong><code>$BATS_TEST_NAME</code></strong> is the name of the function containing the current test case.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print name of current test function</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Function name: $BATS_TEST_NAME&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_TEST_NAME

# <html><h2>Function Names of Test Cases</h2>
# <p><strong><code>$BATS_TEST_NAMES</code></strong> is an array of function names. There&rsquo;s one item
# for each test defined in the current bats test<br />
# file.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print functions corresponding to your defined tests</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example 1&quot; {
# skip
# }
#
# </code></pre>
# </dd>
# </dl>
# <p>@test &ldquo;Example&rdquo; {<br />
# echo &ldquo;Function names: ${BATS_TEST_NAMES[*]}&rdquo; &gt;&amp;3<br />
# }</p>
# <pre><code></code></pre>
# </html>
declare -a BATS_TEST_NAMES

# <html><h2>Index of Current Test Case</h2>
# <p><strong><code>$BATS_TEST_NUMBER</code></strong> is the (1-based) index of the current test case
# in the test file.</p>
# <p><code>$BATS_SUITE_TEST_NUMBER</code> is similar, but for the complete suite.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print current test index</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Index: $BATS_TEST_NUMBER&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare -i BATS_TEST_NUMBER

# Source file generated from the bats file:
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7606/bats.7632.src
export BATS_TEST_SOURCE

# <html><h2>Directory for Temporary Test Case Files</h2>
# <p><strong><code>$BATS_TEST_TMPDIR</code></strong> is the path to the directory for all temporary
# files of the current test case.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print directory path</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;Path: $BATS_TEST_TMPDIR&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_TEST_TMPDIR

# <html><h2>Path to Directory for Temporary Files</h2>
# <p><strong><code>$BATS_TMPDIR</code></strong> is the path to the base directory used by bats to create
# temporary files.</p>
# <h3>Links</h3>
# <ul>
# <li><a href="https://bats-core.readthedocs.io/en/stable/writing-tests.html#special-variables">bats-core
# manual</a></li>
# </ul>
# <h3>Examples</h3>
# <dl>
# <dt>Print path to directory</dt>
# <dd>
# <pre><code class="language-bash">@test &quot;Example&quot; {
# echo &quot;$BATS_TMPDIR&quot; &gt;&amp;3
# }
# </code></pre>
# </dd>
# </dl>
# </html>
declare BATS_TMPDIR

# Temp file name under $BATS_RUN_TMPDIR (not created):
# /var/folders/3c/k3_3r82s08q31699vdnxd2s00000gp/T/bats-run-7606/bats.7642
export BATS_TMPNAME
