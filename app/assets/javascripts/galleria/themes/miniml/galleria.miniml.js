/*
 Galleria Miniml Theme 2011-06-07
 http://galleria.aino.se

 Copyright (c) 2011, Aino
*/
(function (b) {
    Galleria.addTheme({
        name: "miniml",
        author: "Galleria",
        css: "galleria.miniml.css",
        defaults: {
            transition: "slide",
            thumbCrop: "height",
            imageCrop: "height",
            carousel: true,
            imagePan: false,
            clicknext: false,
            _locale: {
                enter_fullscreen: "Enter fullscreen",
                exit_fullscreen: "Exit fullscreen",
                click_to_close: "Click to close",
                show_thumbnails: "Show thumbnails",
                show_info: "Show info"
            }
        },
        init: function (e) {
            var c = this,
                g = !1,
                a;
            a = 0;
            var f, i, h;
            this.addElement("desc", "dots", "thumbs", "fs", "more");
            this.append({
                container: ["desc", "dots", "thumbs", "fs", "info-description", "more"]
            });
            h = this.$("thumbnails-container").hide().css("visibility", "visible");
            var j = function (d) {
                    return b("<div>").click(function (d) {
                        return function (a) {
                            a.preventDefault();
                            c.show(d)
                        }
                    }(d))
                };
            for (a = 0; a < this.getDataLength(); a++) this.$("dots").append(j(a));
            a = this.$("dots").outerWidth();

            // some stuff for non-touch browsers

            this.addIdleState( this.get('image-nav-left'), { left:-50 });
            this.addIdleState( this.get('image-nav-right'), { right:-50 });
            this.addIdleState( this.get('counter'), { opacity:0 });

            f = this.$("desc").hide().hover(function () {
                b(this).addClass("hover")
            }, function () {
                b(this).removeClass("hover")
            }).click(function () {
                b(this).hide()
            });
            i = this.$("loader");


            /*
            this.bindTooltip({
                fs: function () {
                    return g ? e._locale.exit_fullscreen : e._locale.enter_fullscreen
                },
                desc: e._locale.click_to_close,
                more: e._locale.show_info,
                thumbs: e._locale.show_thumbnails
            });*/
            this.bind("loadstart", function (d) {
                d.cached || this.$("loader").show().fadeTo(200, 0.4)
            });
            this.bind("loadfinish", function (d) {
              var a = c.getData().title,
                  b = c.getData().description;
              f.hide();
              i.fadeOut(200);
              this.$("dots").children("div").eq(d.index).addClass("active").siblings(".active").removeClass("active");
              a && b ? (f.empty().append("<strong>" + a + "</strong>", "<p>" + b + "</p>").css({
                  marginTop: this.$("desc").outerHeight() / -2
              }), this.$("more").show()) : this.$("more").hide();
              h.fadeOut(e.fadeSpeed);
              c.$("thumbs").removeClass("active");
            });
            this.bind("thumbnail", function (a) {
                b(a.thumbTarget).hover(function () {
                    c.setInfo(a.index)
                }, function () {
                    c.setInfo()
                })
            });
            this.$("fs").click(function () {
                c.toggleFullscreen();
                g = !g
            });
            this.$("thumbs").click(function (a) {
                a.preventDefault();
                h.toggle();
                b(this).toggleClass("active");
                f.hide()
            });
            this.$("more").click(function () {
                f.toggle()
            });
            this.$("info").css({
                width: this.getStageWidth() - a - 30,
                left: a + 10
            })
        }
    })
})(jQuery);