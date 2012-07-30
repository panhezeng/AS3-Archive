package mvc.model.vo {
	/**
	 * 数据存储
	 * 所有数据都由VO存储，并只有Proxy可以读写(官方示例有极少个别没遵守这个)
	 * 可以有多个VO
	 */
	public class DataVO {
		public var data : Array = [];
	}
}