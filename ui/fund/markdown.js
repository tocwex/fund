import { Marked } from 'marked';
import DOMPurify from 'dompurify';

export function defineMarkdownElement() {
  if (window.customElements.get('zero-md')) return;

  const fundMarkdown = new Marked({
    gfm: true,
    breaks: false,
    renderer: {
      image: ({ href, title, text }) => {
        // FIXME: This is a really gross way to test if the 'zero-md'
        // container is in preview mode; ideally, we'd use CSS instead.
        const isPreview = !/\/project\/(~[^\/]+)\/([^\/]+).*$/.test(window.location.toString());
        const imagElem = document.createElement(isPreview ? "a" : "img");
        if (isPreview) {
          imagElem.setAttribute("href", href);
          imagElem.innerText = text ?? title ?? href;
        } else {
          imagElem.setAttribute("src", href);
          if (text) imagElem.setAttribute("alt", text);
          if (title) imagElem.setAttribute("title", title);
        }
        return imagElem.outerHTML;
      },
    },
  });

  window.customElements.define(
    'zero-md',
    class FundMarkdownElement extends HTMLElement {
      static get observedAttributes() {
        return ["src", "body-class"];
      }
      get bodyClass() {
        const classes = this.getAttribute("body-class");
        return `markdown-body${classes ? ` ${classes}` : ""}`;
      }
      attributeChangedCallback(name, prev, next) {
        if (prev === next || !this.isConnected) return;
        if (name === "body-class") {
          this.querySelector(":scope > .markdown-body")?.setAttribute("class", this.bodyClass);
        } else {
          this.render();
        }
      }
      connectedCallback() {
        this.render();
      }
      async read() {
        const src = this.getAttribute("src");
        if (src) {
          const response = await fetch(src);
          return response.ok ? response.text() : "";
        }
        return this.querySelector(':scope > script[type="text/markdown"]')?.textContent ?? "";
      }
      async render() {
        if (this.rendering) return;
        this.rendering = true;
        try {
          const elem = document.createElement("div");
          elem.setAttribute("id", "fund-loader");
          elem.setAttribute("class", "fund-loader");
          elem.innerText = "⏳";
          if (!this.querySelector(":scope > #fund-loader")) this.appendChild(elem);

          let styles = this.querySelector(":scope > .markdown-styles");
          if (!styles) {
            styles = document.createElement("div");
            styles.setAttribute("class", "markdown-styles");
            this.prepend(styles);
          }
          let body = this.querySelector(":scope > .markdown-body");
          if (!body) {
            body = document.createElement("div");
            body.setAttribute("class", this.bodyClass);
            styles.after(body);
          }

          const template = this.querySelector(":scope > template");
          styles.innerHTML = template?.innerHTML ?? "";

          const text = await this.read();
          const parsed = await fundMarkdown.parse(text);
          body.innerHTML = DOMPurify.sanitize(parsed);
          this.dispatchEvent(new CustomEvent("zero-md-rendered", {
            detail: {styles: true, body: true},
            bubbles: true,
          }));
        } finally {
          this.rendering = false;
        }
      }
    },
  );

  document.addEventListener('zero-md-rendered', (event) => {
    const outer = event.target;
    const loader = Array.from(outer.children).find(e => e.id === "fund-loader");
    if (loader) outer.removeChild(loader);
  });
}
