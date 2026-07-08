import TippyJs from 'tippy.js';
import TomSelect from 'tom-select';

export function initTippy(elem, {
  text=undefined, // String?
  dir=undefined, // String?
  hover=false, // Bool
} = {}) {
  if (elem?._tippy === undefined) {
    var content = text;
    if (!text) {
      // NOTE: Need to keep original 'optElem' because of conflict
      // between Tippy.js (which deletes the original) and Turbo.js
      // (which keeps elements and not JS objects when going forward/back)
      const optElem = elem.nextSibling;
      const tipElem = optElem.cloneNode(true);
      tipElem.style.display = 'block';
      content = tipElem;
    }

    TippyJs(elem, {
      content: content,
      allowHTML: true,
      interactive: true,
      arrow: false,
      trigger: ["click", ...(!hover ? [] : ["mouseenter"])].join(" "),
      theme: "fund",
      offset: [0, 5],
      ...(!dir ? {} : {placement: dir}),
    });
  }
}

export function initTomSelect(elem, {
  empty=false, // Bool
  forceUp=false, // Bool
  asButton=true, // Bool
  maxItems=undefined, // Number?
  create=undefined, // ((value, data) => void)?
  load=undefined, // ((query, callback) => void)?
} = {}) {
  const renderClass = !asButton ? "fund-aset" : "fund-aset-circ";
  function renderSelector(data, escape) {
    return `
      <div class='flex flex-row items-center gap-x-2'>
        <img class='${renderClass}' src='${data.image ??
          "https://placehold.co/24x24/white/black?font=roboto&text=~"
        }' />
        <span>${data.text}</span>
      </div>
    `;
  };

  if (elem?.tomselect === undefined) {
    const tselElem = new TomSelect(elem, {
      allowEmptyOption: empty,
      render: {
        loading: (data, escape) => "<div class='fund-loader'>⏳</div>",
        option: (data, escape) => renderSelector(data, escape),
        item: (data, escape) => renderSelector(data, escape),
        ...(!create ? {} : {
          no_results: (data, escape) => null,
          option_create: (data, escape) => `
            <div class="create">
              Use custom option <strong>${escape(data.input)}</strong>
            </div>`,
        }),
      },
      onDropdownOpen: (dropdown) => {
        if (
            forceUp ||
            (dropdown.getBoundingClientRect().bottom >
            (window.innerHeight || document.documentElement.clientHeight))
        ) {
          dropdown.classList.add('dropup');
        }
      },
      onDropdownClose: (dropdown) => {
        dropdown.classList.remove('dropup');
      },
      ...(empty ? {} : {controlInput: null}),
      ...((maxItems === undefined || maxItems === 0) ? {} : {maxItems}),
      ...(!load ? {} : {load}),
      ...(!create ? {} : {
        create: !!create,
        onOptionAdd: create,
      }),
    });
    tselElem?.load && tselElem.load();
    elem.classList.add("fund-tsel");
    elem.matches(":disabled") && tselElem.disable();
  }
}
