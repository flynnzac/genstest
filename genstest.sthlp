{smcl}
{* *! version 1.0.0 August 20, 2013 @ 11:56:46}{...}
{cmd: help genstest}{right: ({browse "http://stata-journal.com/"})}
{hline}

{title:Title}

{p2colset 5 15 17 2}{...}

{p2col:{hi: genstest} {hline 1} Performs {it:gen}-S tests for models in the {cmd:GMM} framework.}{p_end}
{p2colreset}{...}

{title:Syntax}
{* }{p 8 14 2}

{cmd:genstest} [({it:residual expression}) {cmd:,} {it:test_options} {it:sb_options} {cmd:ci(}{it:ci_options}{cmd:)}]

{title:Description}

{cmd:genstest} implements four types of {it:gen}-S tests: the {it:ave}-S test, the
{it:exp}-S test, the {it:sup}-S test, and the {it:qLL}-S test.  The first
three tests are here referred to collectively as the "single-break" tests as
they are each derived under the assumption that there is a single break date in
the data generating process for the endogenous variables.  The fourth test is
{it:qLL}-S test which is derived by assuming that the instability of the
moments is described as a difference martingale sequence.

{cmd:genstest} may be invoked both as a stand-alone command or as a post-estimation
command for {cmd:gmm}.  In the case that it is used as a post-estimation it will
use all the {cmd:gmm} options that {cmd:genstest} supports.

{title:Options}

{dlgtab:Testing Options}

{phang} {opt instruments}(varlist [, noconstant])
the matrix of instruments.  {cmd:noconstant} indicates removal of a constant
vector from the matrix.
{p_end}

{phang}{opt derivative}(derivative expression) the derivative of a
parameter in the {it:residual expression}.  This option must be specified either
for all parameters to be estimated under the null hypothesis or none (in which
case derivatives will be computed numerically).  This option is specified as in
{cmd:gmm} with the addition that <>'s indicate the value of a parameter tested
under the null hypothesis.  If one is using {cmd:genstest} as a post-estimation
command, the derivatives passed to {cmd:gmm} will be used by {cmd:genstest}.
{p_end}

{phang}{opt null}(numlist | last)
the null hypothesis vector for tested parameters (a zero vector by default).  Must be specified in the
order the parameters appear in the {it:residual expression}.  The special value "last" indicates using the parameter estimates from {cmd:gmm}.
{p_end}

{phang}{opt test}(namelist)
the names of the parameters to test if running {cmd:genstest} as a post-estimation
command for {cmd:gmm}.
{p_end}

{phang}{opt init}(numlist)
the initial values of the untested parameters to be used in their estimation.
{p_end}

{phang}{opt sb } perform the single-break tests.  These are
computationally more intensive than the qLL-S test.

{phang}{opt stab } also report the stability tests (the S-tilde tests).

{phang}{opt winitial}(iwtype)
specify the inital weighting matrix for estimating the untested parameters.  The
choices are an {cmd:identity} matrix or (Z'Z), {cmd:unadjusted}.  The default
option is {cmd:unadjusted}.
{p_end}

{phang}{opt wmatrix}(wmtype)
choose the {cmd:wmatrix}.  The choices are: {cmd:unadjusted}, {cmd:robust},
{cmd:hc}{it:#}, and {cmd:hac} {it:kernel [lags]}.

{phang}{cmd:hc#} specifies a weight matrix robust to heteroskedasticity with four
possible adjustments ({it:#} : 1-4).

{phang}{cmd:hac} {it:kernel [lags]} specifies a weight matrix robust
to autocorrelation and heteroskedasticity.  The possible choices for
{it:kernel} are {cmd:bartlett}, {cmd:gallant}, or {cmd:andrews}.
{it:lags} may be {cmd:optimal} to use the optimal lag selection
algorithm of Newey West, {cmd:automatic} to set the number of lags to
the starting value of the optimal lag selection algorithm, or
{it:number} which is any positive integer.  {p_end}

{phang}{opt center }
recenter the moment function when computing the HAC estimate of the variance.
{p_end}

{phang}{opt twostep }
use the two-step gmm procedure (the default).
{p_end}

{phang}{opt igmm }
use the iterated gmm procedure.
{p_end}

{dlgtab:Single-Break Options}

{phang}{opt trim}(#)
the value of the trimming parameter, {it:s}. The sample will be initially split
at ({it:sT}) where {it:T} is the number of observations.  The possible values
are 0.05, 0.10, 0.15 (the default), and 0.20.
{p_end}

{phang}{opt nuisS }
use the full-sample estimate of the nuisance parameters for the split-sample
tests.
{p_end}

{phang}{opt varS }
use the full-sample weight matrix when estimating the nuisance parameters.
{p_end}

{phang}{opt small } uses a small-sample adjustment to the HAC weight
matrix.  Ignored if not using HAC.  {p_end}

{dlgtab:Confidence Interval}

{phang}{opt ci}(ci_options)}
compute confidence interval (set) using grid-search method.
{p_end}

The following are {it:ci_options}:

{phang}{it:numlist}
For up to two tested parameters, {it:numlist} specifies the range over which to
test the parameters.
{p_end}
{phang}{opt points}(numlist)
the number of equally-spaced points for the grid search.
{p_end}
{phang}{opt alpha}(#)
determines the 1 - {cmd:alpha} coverage probability of the interval or set
(default is 0.05).
{p_end}
{phang}{opt autograph} automatically graph the confidence region in the
case that the region is being computed for two parameters.
{p_end}

{title:Example as a stand-alone command}

{pstd}Examine confidence set for {cmd:rho} and {cmd:theta}, the price indexation
parameter and the price stickiness parameter in the New Keynesian Phillips
Curve.

{phang}. {stata "use nkpc_gmm"}

{phang}. {stata gen time = _n}

{phang}. {stata tsset time}

{phang}. {stata gen dinf = inf - L.inf}

{phang}. {stata genstest (dinf - {c} - (1/(1 + {rho}))*(F.inf - L.inf) -(((1 - <th>)^2)/(<th> * (1 + {rho})))*ls) if time >= 50, inst(L.dinf L.ls L2.ls L3.ls L2.dinf) wmat(hac nwest optimal) center null(0.7) ci(0.3 1.0, points(20))}

{title:Example as a post-estimation command for gmm}

{pstd}Below is the same example using {cmd:genstest} as a post-estimation command.

{phang2}. {stata gmm (dinf - {c} - (1/(1 + {rho}))*(F.inf - L.inf) -(((1 - {th=1})^2)/({th} * (1 + {rho})))*ls) if time >= 50, inst(L.dinf L.ls L2.ls L3.ls L2.dinf) wmat(hac nwest optimal) center}

{phang2}. {stata genstest, null(last) test(th) ci(0.3 1.0, points(20))}

{title:Saved Results}

{title:Saved Results}

{cmd:genstest} saves the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(S)}}S statistic{p_end}
{synopt:{cmd:r(aveS)}}ave-S statistic{p_end}
{synopt:{cmd:r(expS)}}exp-S statistic{p_end}
{synopt:{cmd:r(supS)}}sup-S statistic{p_end}
{synopt:{cmd:r(qllS)}}qLL-S statistic{p_end}

{synopt:{cmd:r(avestabS)}}ave-stab-S statistic{p_end}
{synopt:{cmd:r(expstabS)}}exp-stab-S statistic{p_end}
{synopt:{cmd:r(supstabS)}}sup-stab-S statistic{p_end}
{synopt:{cmd:r(qllstabS)}}qLL-stab-S statistic{p_end}

{synopt:{cmd:r(pS)}}S p-value{p_end}
{synopt:{cmd:r(paveS)}}ave-S p-value{p_end}
{synopt:{cmd:r(pexpS)}}exp-S p-value{p_end}
{synopt:{cmd:r(psupS)}}sup-S p-value{p_end}
{synopt:{cmd:r(pqllS)}}qLL-S p-value{p_end}

{synopt:{cmd:r(pavestabS)}}ave-stab-S p-value{p_end}
{synopt:{cmd:r(pexpstabS)}}exp-stab-S p-value{p_end}
{synopt:{cmd:r(psupstabS)}}sup-stab-S p-value{p_end}
{synopt:{cmd:r(pqllstabS)}}qLL-stab-S p-value{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Sci)}}
grid search points not rejected by the S test or search points and their associated p-values (if {cmd:allpv} is specified).
{p_end}

{synopt:{cmd:r(aveSci)}}
grid search points not rejected by the ave-S test or search points and their associated p-values.
{p_end}

{synopt:{cmd:r(expSci)}}
grid search points not rejected by the exp-S test or search points and their associated p-values.
{p_end}

{synopt:{cmd:r(supSci)}}
grid search points not rejected by the sup-S test or search points and their associated p-values.
{p_end}

{synopt:{cmd:r(qllSci)}}
grid search points not rejected by the qLL-S test or search points and their associated p-values.
{p_end}

{synopt:{cmd:r(avestabSci)}}
grid search points not rejected by the ave-stab-S test or search points and their associated p-values.
{p_end}

{synopt:{cmd:r(expstabSci)}}
grid search points not rejected by the exp-stab-S test or search points and their associated p-values.
{p_end}

{synopt:{cmd:r(supstabSci)}}
grid search points not rejected by the sup-stab-S test or search points and their associated p-values.
{p_end}

{synopt:{cmd:r(qllstabSci)}}
grid search points not rejected by the qLL-stab-S test or search points and their associated p-values.
{p_end}
{p2colreset}{...}
