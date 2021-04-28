export const state = () => ({
  offices: [],
  queryParams: "",
  totalPage: null,
  currentPage: null,
  totalCount: null,
  loading: false,
  office: {
    name: "",
    staffs: [],
    staffNames: [],
    officeId: "",
    targetStaffImage: "",
    targetStaff: "",
    targetStaffKana: "",
    targetStaffBody: "",
  },
  thank: {
    staff: "",
    body: "",
    id: "",
  },
  reserve: {
    office_name: "",
    office_id: "",
    date: "",
    time: "",
    name: "",
    age: "",
    tel: "",
    body: "",
  },
  // reserve_confirm: {
  //   office_name: "",
  //   date: "",
  //   time: "",
  //   name: "",
  //   age: "",
  //   tel: "",
  //   body: "",
  // },
});

export const getters = {
  getOfficesData: (state) => {
    return state.offices.data;
  },
  getCurrentParams: (state) => {
    return state.queryParams;
  },
  getTotalPage: (state) => {
    return state.totalPage;
  },
  getCurrentPage: (state) => {
    return state.currentPage;
  },
  getTotalCount: (state) => {
    return state.totalCount;
  },
  office: (state) => {
    return state.office;
  },
  thank: (state) => {
    return state.thank;
  },
  location: (state) => {
    return state.location;
  },
  reserve: (state) => {
    return state.reserve;
  },
};

export const actions = {
  // キーワード検索と市区町村検索のリクエスト
  async searchOfficesData({ commit }, payload) {
    const queryParams = payload.queryParams;
    const pagePrams = payload.val ? `&page=${payload.val}` : "";
    const url = `/api/offices/search?${queryParams}${pagePrams}`;
    const officesData = await this.$axios.get(url);
    const totalPage = officesData.headers["total-pages"];
    const currentPage = payload.val ? payload.val : 1;
    const totalCount = officesData.headers["total-count"];
    await commit({
      type: "storeOfficesData",
      data: {
        officesData,
        queryParams,
        totalPage,
        currentPage,
        totalCount,
      },
    });
    if (officesData.data.length !== 0) {
      if (!payload.noPush)
        this.$router.push({
          path: "/offices",
          query: Object.assign({}, payload.urlQuery),
        });
    } else {
      alert("検索の条件で該当する事業所は見つかりませんでした。");
    }
  },
  // 新規投稿
  postThankStore({ commit }, payload) {
    commit("postThankMutate", {
      officeName: payload.officeName,
      staffs: payload.staffs,
      officeId: payload.officeId,
    });
    this.$router.push({ name: "users-thanks-new" });
  },
  postConfirmStore({ commit }, payload) {
    commit("postConfirmMutate", {
      staffName: payload.staff,
      thankBody: payload.thankBody,
    });
    this.$router.push({ name: "users-thanks-confirm" });
  },
  // 投稿編集
  async editThankStore({ commit }, payload) {
    const res = await this.$axios.$get(`/api/offices/${payload.officeId}`);
    commit("editThankMutate", {
      officeName: payload.officeName,
      staffs: res.staffs,
      targetStaff: payload.targetStaff,
      thankBody: payload.thankBody,
    });
    this.$router.push({
      name: "users-thanks-edit-id",
      params: { id: payload.editIndex },
    });
  },
  editConfirmStore({ commit }, payload) {
    commit("editConfirmMutate", {
      staffName: payload.staff,
      thankBody: payload.thankBody,
      thankId: payload.thankId,
    });
    this.$router.push({ name: "users-thanks-edit-confirm" });
  },

  async topLocationSearch({ commit }, payload) {
    const url = `api/getoffice?latitude=${payload.latitude}&longitude=${payload.longitude}`;
    const officesData = await this.$axios.get(url);
    const totalPage = officesData.headers["total-pages"];
    const currentPage = payload.val ? payload.val : 1;
    commit({
      type: "storeOfficesData",
      data: {
        officesData,
        totalPage,
        currentPage,
      },
    });
    this.$router.push({ path: "/offices" });
  },

  // 管理者がスタッフを見る
  mystaffStore({ commit }, payload) {
    commit("mystaffMutate", {
      staffImage: payload.staffImage,
      staffName: payload.staffName,
      staffNameKana: payload.staffNameKana,
      staffBody: payload.staffBody,
    });
  },

  // web予約データ
  reserveStore({ commit }, payload) {
    commit("reserveMutate", {
      reserveDate: payload.reserveDate,
      reserveTime: payload.reserveTime,
      reserveName: payload.reserveName,
      reserveAge: payload.reserveAge,
      reserveTel: payload.reserveTel,
      reserveBody: payload.reserveBody,
      reserveOfficeId: payload.reserveOfficeId,
      reserveOfficeName: payload.reserveOfficeName,
    });
    this.$router.push({ name: "reserve-confirm" });
  },
};

export const mutations = {
  storeOfficesData(state, { data }) {
    state.offices = Object.assign({}, data.officesData);
    state.queryParams = data.queryParams;
    state.totalPage = data.totalPage;
    state.currentPage = data.currentPage;
    state.totalCount = data.totalCount;
  },
  setLoading(state, payload) {
    state.loading = payload;
  },
  // 新規投稿
  postThankMutate(state, payload) {
    state.office.name = payload.officeName;
    state.office.staffs = payload.staffs;
    state.office.staffNames = payload.staffs.map((staff) => staff.name);
    state.office.officeId = payload.officeId;
  },
  postConfirmMutate(state, payload) {
    state.thank.staff = payload.staffName;
    state.thank.body = payload.thankBody;
  },
  // 投稿編集
  editThankMutate(state, payload) {
    state.office.name = payload.officeName;
    state.office.staffNames = payload.staffs.map((staff) => staff.name);
    state.office.staffs = payload.staffs;
    state.office.targetStaff = payload.targetStaff;
    state.thank.body = payload.thankBody;
  },
  editConfirmMutate(state, payload) {
    state.thank.staff = payload.staffName;
    state.thank.body = payload.thankBody;
    state.thank.id = payload.thankId;
  },
  // 管理者がスタッフを見る
  mystaffMutate(state, payload) {
    state.office.targetStaffImage = payload.staffImage;
    state.office.targetStaff = payload.staffName;
    state.office.targetStaffKana = payload.staffNameKana;
    state.office.targetStaffBody = payload.staffBody;
  },
  // web予約データ
  reserveMutate(state, payload) {
    state.reserve.date = payload.reserveDate;
    state.reserve.time = payload.reserveTime;
    state.reserve.name = payload.reserveName;
    state.reserve.age = payload.reserveAge;
    state.reserve.tel = payload.reserveTel;
    state.reserve.body = payload.reserveBody;
    state.reserve.office_id = payload.reserveOfficeId;
    state.reserve.office_name = payload.reserveOfficeName;
  },
};
