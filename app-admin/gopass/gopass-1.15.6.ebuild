# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"code.rocketnine.space/tslocum/cbind v0.1.5"
	"code.rocketnine.space/tslocum/cbind v0.1.5/go.mod"
	"filippo.io/age v1.1.1"
	"filippo.io/age v1.1.1/go.mod"
	"filippo.io/edwards25519 v1.0.0"
	"filippo.io/edwards25519 v1.0.0/go.mod"
	"github.com/!proton!mail/go-crypto v0.0.0-20230717121422-5aa5874ade95"
	"github.com/!proton!mail/go-crypto v0.0.0-20230717121422-5aa5874ade95/go.mod"
	"github.com/alessio/shellescape v1.4.2"
	"github.com/alessio/shellescape v1.4.2/go.mod"
	"github.com/atotto/clipboard v0.1.4"
	"github.com/atotto/clipboard v0.1.4/go.mod"
	"github.com/blang/semver/v4 v4.0.0"
	"github.com/blang/semver/v4 v4.0.0/go.mod"
	"github.com/boombuler/barcode v1.0.1-0.20190219062509-6c824513bacc/go.mod"
	"github.com/boombuler/barcode v1.0.1"
	"github.com/boombuler/barcode v1.0.1/go.mod"
	"github.com/bwesterb/go-ristretto v1.2.3/go.mod"
	"github.com/caspr-io/yamlpath v0.0.0-20200722075116-502e8d113a9b"
	"github.com/caspr-io/yamlpath v0.0.0-20200722075116-502e8d113a9b/go.mod"
	"github.com/cenkalti/backoff v2.2.1+incompatible"
	"github.com/cenkalti/backoff v2.2.1+incompatible/go.mod"
	"github.com/cenkalti/backoff/v4 v4.2.1"
	"github.com/cenkalti/backoff/v4 v4.2.1/go.mod"
	"github.com/chzyer/logex v1.2.1"
	"github.com/chzyer/logex v1.2.1/go.mod"
	"github.com/chzyer/readline v1.5.1"
	"github.com/chzyer/readline v1.5.1/go.mod"
	"github.com/chzyer/test v1.0.0"
	"github.com/chzyer/test v1.0.0/go.mod"
	"github.com/cloudflare/circl v1.3.3"
	"github.com/cloudflare/circl v1.3.3/go.mod"
	"github.com/coreos/go-systemd/v22 v22.5.0/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.2"
	"github.com/cpuguy83/go-md2man/v2 v2.0.2/go.mod"
	"github.com/creack/pty v1.1.9/go.mod"
	"github.com/danieljoos/wincred v1.2.0"
	"github.com/danieljoos/wincred v1.2.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dustin/go-humanize v1.0.1"
	"github.com/dustin/go-humanize v1.0.1/go.mod"
	"github.com/fatih/color v1.15.0"
	"github.com/fatih/color v1.15.0/go.mod"
	"github.com/frankban/quicktest v1.14.4"
	"github.com/frankban/quicktest v1.14.4/go.mod"
	"github.com/fsnotify/fsnotify v1.6.0"
	"github.com/fsnotify/fsnotify v1.6.0/go.mod"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/encoding v1.0.0/go.mod"
	"github.com/gdamore/tcell/v2 v2.2.0/go.mod"
	"github.com/gdamore/tcell/v2 v2.6.0"
	"github.com/gdamore/tcell/v2 v2.6.0/go.mod"
	"github.com/gen2brain/shm v0.0.0-20200228170931-49f9650110c5/go.mod"
	"github.com/gen2brain/shm v0.0.0-20221026125803-c33c9e32b1c8"
	"github.com/gen2brain/shm v0.0.0-20221026125803-c33c9e32b1c8/go.mod"
	"github.com/godbus/dbus v0.0.0-20190623212516-8a1682060722"
	"github.com/godbus/dbus v0.0.0-20190623212516-8a1682060722/go.mod"
	"github.com/godbus/dbus/v5 v5.0.4/go.mod"
	"github.com/godbus/dbus/v5 v5.1.0"
	"github.com/godbus/dbus/v5 v5.1.0/go.mod"
	"github.com/gokyle/twofactor v1.0.1"
	"github.com/gokyle/twofactor v1.0.1/go.mod"
	"github.com/golang/mock v1.6.0"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/golang/protobuf v1.3.2/go.mod"
	"github.com/golang/protobuf v1.5.0/go.mod"
	"github.com/golang/protobuf v1.5.3"
	"github.com/golang/protobuf v1.5.3/go.mod"
	"github.com/google/go-cmp v0.3.0/go.mod"
	"github.com/google/go-cmp v0.5.2/go.mod"
	"github.com/google/go-cmp v0.5.5/go.mod"
	"github.com/google/go-cmp v0.5.9"
	"github.com/google/go-cmp v0.5.9/go.mod"
	"github.com/google/go-github v17.0.0+incompatible"
	"github.com/google/go-github v17.0.0+incompatible/go.mod"
	"github.com/google/go-github/v33 v33.0.0"
	"github.com/google/go-github/v33 v33.0.0/go.mod"
	"github.com/google/go-querystring v1.0.0/go.mod"
	"github.com/google/go-querystring v1.1.0"
	"github.com/google/go-querystring v1.1.0/go.mod"
	"github.com/gopasspw/gopass-hibp v1.15.5"
	"github.com/gopasspw/gopass-hibp v1.15.5/go.mod"
	"github.com/hashicorp/golang-lru v0.5.4"
	"github.com/hashicorp/golang-lru v0.5.4/go.mod"
	"github.com/hashicorp/golang-lru/v2 v2.0.4"
	"github.com/hashicorp/golang-lru/v2 v2.0.4/go.mod"
	"github.com/jezek/xgb v0.0.0-20210312150743-0e0f116e1240/go.mod"
	"github.com/jezek/xgb v1.1.0"
	"github.com/jezek/xgb v1.1.0/go.mod"
	"github.com/jsimonetti/pwscheme v0.0.0-20220922140336-67a4d090f150"
	"github.com/jsimonetti/pwscheme v0.0.0-20220922140336-67a4d090f150/go.mod"
	"github.com/jwalton/gchalk v1.3.0"
	"github.com/jwalton/gchalk v1.3.0/go.mod"
	"github.com/jwalton/go-supportscolor v1.1.0/go.mod"
	"github.com/jwalton/go-supportscolor v1.2.0"
	"github.com/jwalton/go-supportscolor v1.2.0/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
	"github.com/kbinani/screenshot v0.0.0-20210720154843-7d3a670d8329"
	"github.com/kbinani/screenshot v0.0.0-20210720154843-7d3a670d8329/go.mod"
	"github.com/kjk/lzmadec v0.0.0-20210713164611-19ac3ee91a71"
	"github.com/kjk/lzmadec v0.0.0-20210713164611-19ac3ee91a71/go.mod"
	"github.com/klauspost/compress v1.16.7"
	"github.com/klauspost/compress v1.16.7/go.mod"
	"github.com/kr/pretty v0.2.1/go.mod"
	"github.com/kr/pretty v0.3.1"
	"github.com/kr/pretty v0.3.1/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/kr/text v0.2.0"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.2.0"
	"github.com/lucasb-eyer/go-colorful v1.2.0/go.mod"
	"github.com/lxn/win v0.0.0-20210218163916-a377121e959e"
	"github.com/lxn/win v0.0.0-20210218163916-a377121e959e/go.mod"
	"github.com/makiuchi-d/gozxing v0.1.1"
	"github.com/makiuchi-d/gozxing v0.1.1/go.mod"
	"github.com/martinhoefling/goxkcdpwgen v0.1.2-0.20221205222637-737661b92a0e"
	"github.com/martinhoefling/goxkcdpwgen v0.1.2-0.20221205222637-737661b92a0e/go.mod"
	"github.com/mattn/go-colorable v0.1.4/go.mod"
	"github.com/mattn/go-colorable v0.1.12/go.mod"
	"github.com/mattn/go-colorable v0.1.13"
	"github.com/mattn/go-colorable v0.1.13/go.mod"
	"github.com/mattn/go-isatty v0.0.8/go.mod"
	"github.com/mattn/go-isatty v0.0.10/go.mod"
	"github.com/mattn/go-isatty v0.0.14/go.mod"
	"github.com/mattn/go-isatty v0.0.16/go.mod"
	"github.com/mattn/go-isatty v0.0.19"
	"github.com/mattn/go-isatty v0.0.19/go.mod"
	"github.com/mattn/go-runewidth v0.0.7/go.mod"
	"github.com/mattn/go-runewidth v0.0.10/go.mod"
	"github.com/mattn/go-runewidth v0.0.14/go.mod"
	"github.com/mattn/go-runewidth v0.0.15"
	"github.com/mattn/go-runewidth v0.0.15/go.mod"
	"github.com/mattn/go-tty v0.0.5"
	"github.com/mattn/go-tty v0.0.5/go.mod"
	"github.com/mitchellh/go-ps v1.0.0"
	"github.com/mitchellh/go-ps v1.0.0/go.mod"
	"github.com/muesli/crunchy v0.4.0"
	"github.com/muesli/crunchy v0.4.0/go.mod"
	"github.com/nbutton23/zxcvbn-go v0.0.0-20210217022336-fa2cb2858354"
	"github.com/nbutton23/zxcvbn-go v0.0.0-20210217022336-fa2cb2858354/go.mod"
	"github.com/noborus/guesswidth v0.3.4"
	"github.com/noborus/guesswidth v0.3.4/go.mod"
	"github.com/noborus/ov v0.31.0"
	"github.com/noborus/ov v0.31.0/go.mod"
	"github.com/pierrec/lz4 v2.6.1+incompatible"
	"github.com/pierrec/lz4 v2.6.1+incompatible/go.mod"
	"github.com/pkg/diff v0.0.0-20210226163009-20ebb0f2a09e/go.mod"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/pquerna/otp v1.4.0"
	"github.com/pquerna/otp v1.4.0/go.mod"
	"github.com/rivo/uniseg v0.1.0/go.mod"
	"github.com/rivo/uniseg v0.2.0/go.mod"
	"github.com/rivo/uniseg v0.4.3/go.mod"
	"github.com/rivo/uniseg v0.4.4"
	"github.com/rivo/uniseg v0.4.4/go.mod"
	"github.com/rogpeppe/go-internal v1.9.0"
	"github.com/rogpeppe/go-internal v1.9.0/go.mod"
	"github.com/rs/xid v1.5.0/go.mod"
	"github.com/rs/zerolog v1.30.0"
	"github.com/rs/zerolog v1.30.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.1.0"
	"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
	"github.com/schollz/closestmatch v0.0.0-20190308193919-1fbe626be92e"
	"github.com/schollz/closestmatch v0.0.0-20190308193919-1fbe626be92e/go.mod"
	"github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e"
	"github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e/go.mod"
	"github.com/spf13/pflag v1.0.3/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.5.0"
	"github.com/stretchr/testify v1.1.4/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.8.4"
	"github.com/stretchr/testify v1.8.4/go.mod"
	"github.com/twpayne/go-pinentry v0.2.0"
	"github.com/twpayne/go-pinentry v0.2.0/go.mod"
	"github.com/ulikunitz/xz v0.5.11"
	"github.com/ulikunitz/xz v0.5.11/go.mod"
	"github.com/urfave/cli/v2 v2.25.7"
	"github.com/urfave/cli/v2 v2.25.7/go.mod"
	"github.com/xrash/smetrics v0.0.0-20170218160415-a3153f7040e9/go.mod"
	"github.com/xrash/smetrics v0.0.0-20201216005158-039620a65673"
	"github.com/xrash/smetrics v0.0.0-20201216005158-039620a65673/go.mod"
	"github.com/yuin/goldmark v1.4.13/go.mod"
	"github.com/zalando/go-keyring v0.2.3"
	"github.com/zalando/go-keyring v0.2.3/go.mod"
	"go.uber.org/multierr v1.11.0"
	"go.uber.org/multierr v1.11.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
	"golang.org/x/crypto v0.0.0-20220919173607-35f4265a4bc0/go.mod"
	"golang.org/x/crypto v0.3.1-0.20221117191849-2c476679df9a/go.mod"
	"golang.org/x/crypto v0.7.0/go.mod"
	"golang.org/x/crypto v0.11.0"
	"golang.org/x/crypto v0.11.0/go.mod"
	"golang.org/x/exp v0.0.0-20230728194245-b0cb94b80691"
	"golang.org/x/exp v0.0.0-20230728194245-b0cb94b80691/go.mod"
	"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
	"golang.org/x/mod v0.8.0/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/net v0.0.0-20190603091049-60506f45cf65/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/net v0.0.0-20211112202133-69e39bad7dc2/go.mod"
	"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
	"golang.org/x/net v0.0.0-20220921155015-db77216a4ee9/go.mod"
	"golang.org/x/net v0.2.0/go.mod"
	"golang.org/x/net v0.6.0/go.mod"
	"golang.org/x/net v0.8.0/go.mod"
	"golang.org/x/net v0.12.0"
	"golang.org/x/net v0.12.0/go.mod"
	"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
	"golang.org/x/oauth2 v0.10.0"
	"golang.org/x/oauth2 v0.10.0/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
	"golang.org/x/sync v0.1.0/go.mod"
	"golang.org/x/sync v0.3.0"
	"golang.org/x/sync v0.3.0/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
	"golang.org/x/sys v0.0.0-20191008105621-543471e840be/go.mod"
	"golang.org/x/sys v0.0.0-20191120155948-bd437916bb0e/go.mod"
	"golang.org/x/sys v0.0.0-20201018230417-eeed37f84f13/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210220050731-9a76102bfb43/go.mod"
	"golang.org/x/sys v0.0.0-20210309040221-94ec62e08169/go.mod"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
	"golang.org/x/sys v0.0.0-20210927094055-39ccf1dd6fa6/go.mod"
	"golang.org/x/sys v0.0.0-20211004093028-2c5d950f24ef/go.mod"
	"golang.org/x/sys v0.0.0-20220310020820-b874c991c1a5/go.mod"
	"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
	"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
	"golang.org/x/sys v0.0.0-20220728004956-3c1f35247d10/go.mod"
	"golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod"
	"golang.org/x/sys v0.0.0-20220908164124-27713097b956/go.mod"
	"golang.org/x/sys v0.0.0-20220919091848-fb04ddd9f9c8/go.mod"
	"golang.org/x/sys v0.2.0/go.mod"
	"golang.org/x/sys v0.3.0/go.mod"
	"golang.org/x/sys v0.5.0/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.10.0"
	"golang.org/x/sys v0.10.0/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/term v0.0.0-20201210144234-2321bbc49cbf/go.mod"
	"golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d/go.mod"
	"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
	"golang.org/x/term v0.0.0-20220919170432-7a66f970e087/go.mod"
	"golang.org/x/term v0.2.0/go.mod"
	"golang.org/x/term v0.5.0/go.mod"
	"golang.org/x/term v0.6.0/go.mod"
	"golang.org/x/term v0.10.0"
	"golang.org/x/term v0.10.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.5/go.mod"
	"golang.org/x/text v0.3.6/go.mod"
	"golang.org/x/text v0.3.7/go.mod"
	"golang.org/x/text v0.4.0/go.mod"
	"golang.org/x/text v0.7.0/go.mod"
	"golang.org/x/text v0.8.0/go.mod"
	"golang.org/x/text v0.11.0"
	"golang.org/x/text v0.11.0/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20190624222133-a101b041ded4/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.1.12/go.mod"
	"golang.org/x/tools v0.6.0/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"golang.org/x/xerrors v0.0.0-20220907171357-04be3eba64a2"
	"golang.org/x/xerrors v0.0.0-20220907171357-04be3eba64a2/go.mod"
	"google.golang.org/appengine v1.1.0/go.mod"
	"google.golang.org/appengine v1.6.7"
	"google.golang.org/appengine v1.6.7/go.mod"
	"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
	"google.golang.org/protobuf v1.26.0/go.mod"
	"google.golang.org/protobuf v1.31.0"
	"google.golang.org/protobuf v1.31.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200121175148-a6ecf24a6d71/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
	"gotest.tools/v3 v3.0.2"
	"gotest.tools/v3 v3.0.2/go.mod"
	"rsc.io/qr v0.2.0"
	"rsc.io/qr v0.2.0/go.mod"
)

go-module_set_globals

DESCRIPTION="a simple but powerful password manager for the terminal"
HOMEPAGE="https://www.gopass.pw/"
SRC_URI="https://github.com/gopasspw/gopass/tarball/aeefd4f0964018a2f2cce9af4f4e3311d617f0cc -> gopass-1.15.6-aeefd4f.tar.gz
https://direct.funtoo.org/2f/6d/5f/2f6d5f65f25488fd1e6b02d004cc557358d455bb7e5d6f3e3ac519295af3f186c63b07022580b9a1230a1f9511c46e449277f6d1f98a291a6477d8d2565d33ed -> gopass-1.15.6-funtoo-go-bundle-681050d718d853233c036226dde218b281e44cd8885cc1064f3eba63667a6f13dc16b2e4928929fe39f5b1e6301429315aaf25f8e4a5a42ef6d5086c896add9c.tar.gz"

LICENSE="MIT Apache-2.0 BSD MPL-2.0 BSD-2"
SLOT="0"
KEYWORDS="*"

RESTRICT="strip test"

QA_PRESTRIPPED="usr/bin/gopass"

DEPEND="dev-lang/go"
RDEPEND="
	dev-vcs/git
	app-crypt/gnupg
"

post_src_unpack() {
	mv "${WORKDIR}"/gopasspw-gopass-* "${S}" || die
}

src_install() {
	emake install DESTDIR="${ED}/usr"
	einstalldocs
}

pkg_postinst() {
	echo "browser integration app-admin/gopass-jsonapi"
	echo "git credentials helper app-admin/git-credential-gopass"
	echo "haveibeenpwnd.com integration app-admin/gopass-hibp"
	echo "summon secrets helper app-admin/gopass-summon-provider"
}