#import "dependency.typ": * // 导入依赖文件

#let CUGB-red = rgb("#880000") // 定义中国地质大学红色
#let CUGB-blue = rgb("#004b88") // 定义中国地质大学蓝色
// #let CUGB-logo = {image("img/logo.png", height: 20%)} // 可选：定义 logo 图片
#set text(region: "CN") // 设置文本区域为中国

#let primary = CUGB-blue // 主题主色
#let primary-dark = rgb("#880000") // 主题深色
#let secondary = rgb("#ffffff") // 辅助色
#let neutral-lightest = rgb("#ffffff") // 最浅中性色
#let neutral-darkest = rgb("#000000") // 最深中性色
#let themeblue = rgb("#4285f4") // 主题蓝色
#let themegreen = rgb("#34a853") // 主题绿色
#let themeyellow = rgb("#fbbc05") // 主题黄色
#let themered = rgb("#ea4335") // 主题红色

#let tblock(title: none, it) = { // 定义带标题的主题色块
  grid(
    columns: 1,
    row-gutter: 0pt,
    block(
      fill: primary, // 标题块背景色
      width: 100%,
      radius: (top: 6pt), // 顶部圆角
      inset: (top: 0.4em, bottom: 0.3em, left: 0.5em, right: 0.5em), // 内边距
      text(fill: neutral-lightest, weight: "bold", title), // 标题文本样式
    ),
    rect(
      fill: gradient.linear(primary-dark, primary.lighten(90%), angle: 90deg), // 渐变分割线
      width: 100%,
      height: 4pt,
    ),
    block(
      fill: primary.lighten(90%), // 内容块背景色
      width: 100%,
      radius: (bottom: 6pt), // 底部圆角
      inset: (top: 0.4em, bottom: 0.5em, left: 0.5em, right: 0.5em), // 内边距
      it, // 内容
    ),
  )
}

#let outline-slide(title: [目录], column: 2, marker: auto, ..args) = touying-slide-wrapper(self => {
  let info = self.info + args.named() // 合并参数
  let header = { // 页眉样式
    set align(center + bottom)
    block(
      fill: self.colors.neutral-lightest, // 页眉背景色
      outset: (x: 2.4em, y: .8em), // 外边距
      stroke: (bottom: self.colors.primary + 3.2pt), // 底部描边
      text(self.colors.primary, weight: "bold", size: 2.6em, title), // 页眉标题样式
    )
  }
  let body = { // 目录主体内容
    set align(horizon)
    show outline.entry: it => { // 展示目录条目
      let mark = if (marker == auto) {
        image("img/button.png", height: .8em) // 默认条目前图标
      } else if type(marker) == image {
        set image(height: .8em)
        image
      } else if type(marker) == symbol {
        text(fill: self.colors.primary, marker)
      }
      block(stack(dir: ltr, spacing: .8em, mark, link(it.element.location(), it.body())), below: 0pt,)
    }
    show: pad.with(x: 3.1em) // 左侧内边距
    pad(left:0%)[
      #outline(title: none, indent: 1em, depth: 1) // 生成目录
    ]
  }
  self = utils.merge-dicts(
    self,
    config-page(
      header: header + v(-4em), // 页眉向上偏移
      margin: (top: 0.5em, bottom: 1.6em),
      fill: self.colors.neutral-lightest, // 页面背景色
    ),
  )
  touying-slide(self: self, body) // 渲染幻灯片
})

#let title-slide(
  config: (:),
  extra: none,
  overplay-images: (), // 允许叠加图片
  ..args,
) = touying-slide-wrapper(self => {
  self = ty.utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true), // 封面不显示页码
    config-page(margin: 0em), // 无边距
  )
  set align(center) // 居中对齐
  let info = self.info + args.named()
  let body = {
    // 设置封面底版图片为"图片2.png"
    image("img/图片2.png", width: 100%, height: 100%)
    // 允许叠加其它图片
    for img in overplay-images {
      place(img)
    }
    // 更改封面字体设置
    let content = {
      align(
      center,
      pad(top: 0cm)[
        #image("img/logo.png") // 在内容上方中间叠加 logo
      ],
    )
      set align(center)
      text(
        size: 1.35em,
        fill: black,
        weight: "bold",
        info.title, // 标题
      )
      if info.subtitle != none {
        parbreak()
        text(size: 1.0em, fill: self.colors.neutral-darkest, weight: "bold", info.subtitle) // 副标题
      }
      grid(
        text(fill: black, info.author) // 作者
      )
      if info.institution != none {
        parbreak()
        text(size: 0.8em, fill: black, info.institution) // 单位
      }
      if info.date != none {
        parbreak()
        text(size: 1.0em, fill: black, info.date.display()) // 日期
      }
    }
    place(
      dx: 2em,
      dy: -21.2em,
      content, // 将内容叠加到指定位置
    )
  }
  touying-slide(self: self, body) // 渲染封面幻灯片
})

#let CUGB-footer(self) = { // 页脚样式
  set align(bottom + center)
  set text(size: 0.8em)
  show: pad.with(.0em)
  block(
    width: 100%,
    height: 1.5em,
    fill: self.colors.primary, // 页脚背景色
    pad(
      y: .4em,
      x: 2em,
      grid(
        columns: (auto, 1fr, auto, auto), // 页脚分为三部分
        text(fill: self.colors.neutral-lightest, ty.utils.call-or-display(self, self.store.footer-a)), // 左侧内容
        utils.fit-to-width(grow: false,100%,text(fill: self.colors.neutral-lightest.lighten(40%), ty.utils.call-or-display(self, self.store.footer-b))), // 中间内容
        text(fill: self.colors.neutral-lightest.lighten(10%), ty.utils.call-or-display(self, self.store.footer-c)), // 右侧内容
      ),
    ),
  )
}

#let slide(
  title: auto,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = { // 幻灯片页眉
    set std.align(top)
    ty.components.progress-bar(height: 8pt, self.colors.primary.lighten(20%), self.colors.primary.lighten(40%)) // 顶部进度条
    set text(fill: self.colors.neutral-lightest, weight: "bold", size: 1.2em) // 页眉文字样式
    set std.align(horizon)
    // v(1em)
    show: components.cell.with(fill: self.colors.primary, inset: 2em) // 页眉背景块
    utils.fit-to-width(grow: false,100%,ty.utils.display-current-heading(level: 2, numbered: false)) // 显示当前章节标题
  }
  self = ty.utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: false), // 显示页码
    config-page(),
  )
  let self = ty.utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.neutral-lightest, // 页面背景色
      header: header, // 页眉
      footer: self.methods.footer, // 页脚
    ),
  )
  let new-setting = body => {
    show: std.align.with(horizon)
    set text(fill: self.colors.neutral-darkest)
    show: setting
    body
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies) // 渲染内容页
})

#let new-section-slide(config: (:), level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  let header = { // 新章节页眉
    set std.align(top)
    ty.components.progress-bar(height: 8pt, self.colors.primary, self.colors.primary.lighten(40%)) // 章节进度条
  }
  let slide-body = {
    set std.align(center)
    show: pad.with(20%) // 内容居中并加大内边距
    set text(size: 2.5em)
    v(1.5em)
    stack(
      dir: ttb,
      spacing: 0.5em,
      text(self.colors.neutral-darkest, utils.display-current-heading(level: level, numbered: numbered, style: auto)), // 显示章节标题
      block(
        height: 2pt,
        width: 100%,
        spacing: 0pt,
        components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light), // 章节分割线
      ),
    )
    text(self.colors.neutral-dark, body) // 章节内容
  }
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lightest, header: header),
  )
  touying-slide(self: self, config: config, slide-body) // 渲染章节页
})

#let ending-slide(config: (:), title: none, body) = touying-slide-wrapper(self => {
  // image("img/图片2.png", width: 100%, height: 100%)
    // 允许叠加其它图片
    // for img in overplay-images {
    //   place(img)
    // }
  let content = {
     // 在内容上方中间叠加 logo
    set align(center)
    image("img/logo.png", height: 20%)
    if title != none {
      block(
        fill: self.colors.tertiary,
        inset: (top: 0.7em, bottom: 0.7em, left: 3em, right: 3em),
        radius: 0.5em,
        text(size: 1.5em, fill: self.colors.neutral-dark, title), // 结束页标题
      )
    }
    body // 结束页内容
  }
  // place(
  //   dx: 2em,
  //   dy: -21.2em,
  //   content, // 将内容叠加到指定位置
  // )
  touying-slide(self: self, content) // 渲染结束页
})

#let focus-slide(body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true), // 不显示页码
    config-page(
      fill: self.colors.primary, // 背景色
      margin: 2em,
      header: none,
      footer: none,
    ),
  )
  set text(fill: self.colors.neutral-lightest, weight: "bold", size: 1.5em)
  touying-slide(self: self, align(horizon+center, body)) // 内容居中显示
})

#let matrix-slide(config: (:), columns: none, rows: none, ..bodies) = touying-slide-wrapper(self => {
  self = ty.utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em),
  )
  touying-slide(
    self: self,
    config: config,
    composer: (..bodies) => {
      let bodies = bodies.pos()
      let columns = if type(columns) == int {
        (1fr,) * columns // 指定列数
      } else if columns == none {
        (1fr,) * bodies.len() // 默认每个内容一列
      } else {
        columns
      }
      let num-cols = columns.len()
      let rows = if type(rows) == int {
        (1fr,) * rows // 指定行数
      } else if rows == none {
        let quotient = calc.quo(bodies.len(), num-cols)
        let correction = if calc.rem(bodies.len(), num-cols) == 0 { 0 } else { 1 }
        (1fr,) * (quotient + correction) // 自动计算行数
      } else {
        rows
      }
      let num-rows = rows.len()
      if num-rows * num-cols < bodies.len() {
        panic(
          "number of rows ("
            + str(num-rows)
            + ") * number of columns ("
            + str(num-cols)
            + ") must at least be number of content arguments ("
            + str(bodies.len())
            + ")",
        )
      }
      let cart-idx(i) = (calc.quo(i, num-cols), calc.rem(i, num-cols)) // 计算行列索引
      let color-body(idx-body) = {
        let (idx, body) = idx-body
        let (row, col) = cart-idx(idx)
        let color = if calc.even(row + col) { self.colors.neutral-lightest } else { silver } // 交错背景色
        set align(center + horizon)
        rect(inset: .5em, width: 100%, height: 100%, fill: color, body) // 内容块
      }
      let content = grid(
        columns: columns, rows: rows,
        gutter: 0pt,
        ..bodies.enumerate().map(color-body) // 生成矩阵内容
      )
      content
    },
    ..bodies,
  )
})

#let CUGB-theme(
  aspect-ratio: "16-9", // 幻灯片比例
  header: self => utils.display-current-heading(
    setting: utils.fit-to-width.with(grow: false, 100%),
    depth: self.slide-level,
  ), // 页眉内容
  // header-image: "img/logo.png", // 可选：页眉图片
  footer-a: self => self.info.date.display(), // 页脚左侧内容
  footer-b: self => if self.info.short-title == auto {
    self.info.title
  } else {
    self.info.short-title
  }, // 页脚中间内容
  footer-c: context ty.utils.slide-counter.display() + " / " + ty.utils.last-slide-number, // 页脚右侧内容
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-colors(
      primary: primary,
      primary-dark: primary-dark,
      secondary: secondary,
      neutral-lightest: neutral-lightest,
      neutral-darkest: neutral-darkest,
      themeblue: themeblue,
      themegreen: themegreen,
      themeyellow: themeyellow,
      themered: themered,
    ), // 主题色配置
    config-store(
      align: align,
      alpha: 60%,
      footer: true,
      header: header,
      header-right: none, // 页眉右侧内容为空
      // header-image: header-image,
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
    ), // 幻灯片全局配置
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ), // 幻灯片通用配置
    config-page(
      paper: "presentation-" + aspect-ratio, // 幻灯片纸张比例
      margin: (top: 2.4em, bottom: 1.7em, x: 2.5em),
      header-ascent: 10%,
      footer-descent: 30%,
    ), // 页面配置
    config-methods(
      d-cover: (self: none, body) => {
        utils.cover-with-rect(
          fill: utils.update-alpha(
            constructor: rgb,
            self.page-args.fill,
            self.d-alpha,
          ),
          body,
        )
      }, // 封面覆盖方法
      footer: CUGB-footer, // 页脚方法
      alert: (self: none, it) => text(fill: self.colors.primary, it), // 警告样式
      init: (self: none, body) => {
        set text(size: 20pt)
        show heading: set text(fill: self.colors.primary)
        set list(marker: (text([#v(-0.2em)‣], fill: self.colors.primary, size: 1.6em),
                          text([--], fill: self.colors.primary)))
        show figure.caption: set text(size: 0.6em)
        show footnote.entry: set text(size: 0.6em)
        show link: it => if type(it.dest) == str {
          set text(fill: self.colors.primary)
          it
        } else {
          it
        }
        body // 初始化样式
      },
    ),
    ..args,
  )
  body // 渲染主体内容
}
